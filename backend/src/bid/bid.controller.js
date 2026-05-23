import * as bidService from './bid.service.js';
import prisma from '../shared/prisma.client.js';

async function placeBid(req, res, next) {
  try {
    const { propertyId } = req.params;
    const { amount } = req.body;
    const bidderId = req.user.id;

    console.log(`[BID REQUEST] Placing bid for property: ${propertyId}`);
    console.log(`[BID REQUEST] Bidder: ${bidderId}, Amount: ${amount}`);
    console.log(`[BID REQUEST] File uploaded: ${req.file ? req.file.filename : 'No file'}`);

    if (!amount || isNaN(parseFloat(amount))) {
      const error = new Error('A valid bid amount is required');
      error.statusCode = 400;
      throw error;
    }

    let bankStatementUrl = null;
    if (req.file) {

      bankStatementUrl = `/public/uploads/${req.file.filename}`;
    }

    const newBid = await bidService.placeBid(
      propertyId,
      bidderId,
      parseFloat(amount),
      bankStatementUrl
    );

    res.status(201).json({
      status: 'success',
      message: 'Bid placed successfully',
      data: newBid
    });
  } catch (error) {
    next(error);
  }
}


async function retractBid(req, res, next) {
  try {
    const { id } = req.params;
    const bidderId = req.user.id;

    const retractedBid = await bidService.retractBid(id, bidderId);

    res.status(200).json({
      status: 'success',
      message: 'Bid retracted successfully',
      data: retractedBid
    });
  } catch (error) {
    next(error);
  }
}

/**
 * Accept a bid (Seller only).
 * Expects: bidId in params.
 */
async function acceptBid(req, res, next) {
  try {
    const { id } = req.params;
    const sellerId = req.user.id;

    const acceptedBid = await bidService.acceptBid(id, sellerId);

    res.status(200).json({
      status: 'success',
      message: 'Bid accepted successfully. Auction closed.',
      data: acceptedBid
    });
  } catch (error) {
    next(error);
  }
}

/**
 * Get all bids for a specific property (useful for property page display).
 */
async function getPropertyBids(req, res, next) {
  try {
    const { propertyId } = req.params;

    const bids = await prisma.bid.findMany({
      where: { propertyId },
      include: {
        bidder: {
          include: {
            user: {
              select: { name: true, email: true }
            }
          }
        }
      },
      orderBy: { amount: 'desc' }
    });

    res.status(200).json({
      status: 'success',
      results: bids.length,
      data: bids
    });
  } catch (error) {
    next(error);
  }
}

export { placeBid, retractBid, acceptBid, getPropertyBids };
