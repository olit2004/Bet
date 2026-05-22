import prisma from '../shared/prisma.client.js';


async function placeBid(propertyId, bidderId, amount, bankStatementUrl = null) {
    return prisma.$transaction(async (tx) => {

        const property = await tx.property.findUnique({
            where: { id: propertyId },
            include: {
                bids: {
                    where: { status: 'ACTIVE' },
                    orderBy: { amount: 'desc' },
                    take: 1
                }
            }
        });

        if (!property) {
            const error = new Error('Property not found');
            error.statusCode = 404;
            throw error;
        }

        if (property.listingType !== 'AUCTION') {
            const error = new Error('This property is not listed for auction');
            error.statusCode = 400;
            throw error;
        }

        if (property.status !== 'ACTIVE') {
            const error = new Error('This auction is no longer active');
            error.statusCode = 400;
            throw error;
        }

        if (property.endTime && new Date() > new Date(property.endTime)) {
            const error = new Error('This auction has already ended');
            error.statusCode = 400;
            throw error;
        }


        const highestBid = property.bids.length > 0 ? property.bids[0] : null;
        const minBidRequired = highestBid ? highestBid.amount : property.price;

        if (amount <= minBidRequired) {
            const error = new Error(`Bid amount must be greater than the current highest bid or starting price (${minBidRequired})`);
            error.statusCode = 400;
            throw error;
        }


        const newBid = await tx.bid.create({
            data: {
                propertyId,
                bidderId,
                amount,
                bankStatementUrl,
                status: 'ACTIVE'
            }
        });


        if (highestBid && highestBid.bidderId !== bidderId) {
            await tx.notification.create({
                data: {
                    userId: highestBid.bidderId,
                    type: 'OUTBID',
                    message: `You have been outbid on property: ${property.title}. New highest bid is ${amount}.`
                }
            });
        }

        return newBid;
    });
}

/**
 * Retracts a bid.
 */
async function retractBid(bidId, bidderId) {
    const bid = await prisma.bid.findUnique({
        where: { id: bidId },
        include: { property: true }
    });

    if (!bid) {
        const error = new Error('Bid not found');
        error.statusCode = 404;
        throw error;
    }

    if (bid.bidderId !== bidderId) {
        const error = new Error('You do not have permission to retract this bid');
        error.statusCode = 403;
        throw error;
    }

    if (bid.property.status !== 'ACTIVE') {
        const error = new Error('Cannot retract a bid on a closed auction');
        error.statusCode = 400;
        throw error;
    }

    if (bid.status !== 'ACTIVE') {
        const error = new Error(`Cannot retract a bid with status: ${bid.status}`);
        error.statusCode = 400;
        throw error;
    }

    return prisma.bid.update({
        where: { id: bidId },
        data: { status: 'RETRACTED' }
    });
}


async function acceptBid(bidId, sellerId) {
    return prisma.$transaction(async (tx) => {
        const bid = await tx.bid.findUnique({
            where: { id: bidId },
            include: { property: true }
        });

        if (!bid) {
            const error = new Error('Bid not found');
            error.statusCode = 404;
            throw error;
        }

        if (bid.property.ownerId !== sellerId) {
            const error = new Error('You do not have permission to accept bids for this property');
            error.statusCode = 403;
            throw error;
        }

        if (bid.property.status !== 'ACTIVE') {
            const error = new Error('This auction is already closed or ended');
            error.statusCode = 400;
            throw error;
        }

        if (bid.status !== 'ACTIVE') {
            const error = new Error('You can only accept active bids');
            error.statusCode = 400;
            throw error;
        }

        // Mark the winning bid as ACCEPTED
        const acceptedBid = await tx.bid.update({
            where: { id: bidId },
            data: { status: 'ACCEPTED' }
        });

        // Mark all other active bids on this property as DECLINED
        await tx.bid.updateMany({
            where: {
                propertyId: bid.propertyId,
                id: { not: bidId },
                status: 'ACTIVE'
            },
            data: { status: 'DECLINED' }
        });

        // Close the property auction
        await tx.property.update({
            where: { id: bid.propertyId },
            data: { status: 'ENDED' }
        });

        // Notify the winning bidder
        await tx.notification.create({
            data: {
                userId: bid.bidderId,
                type: 'AUCTION_ENDED',
                message: `Congratulations! Your bid of ${bid.amount} for property '${bid.property.title}' has been accepted.`
            }
        });

        return acceptedBid;
    });
}

export { placeBid, retractBid, acceptBid };
