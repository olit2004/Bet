import bidService from './bid.service.js';
import prisma from '../shared/db.js';

/**
 * Place a new bid on a property.
 * Expects: propertyId in params, amount in body, optional file in req.file.
 */
async function placeBid(req, res, next) {
  try {
    const { propertyId } = req.params;
    const { amount } = req.body;
    const bidderId = req.user.id;

    if (!amount || isNaN(parseFloat(amount))) {
      const error = new Error('A valid bid amount is required');
      error.statusCode = 400;
      throw error;
    }

    let bankStatementUrl = null;
    if (req.file) {
      // Store the relative path so the frontend can retrieve it statically
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

/**
 * Retract an existing bid.
 * Expects: bidId in params.
 */
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

export default {
  placeBid,
  retractBid,
  acceptBid,
  getPropertyBids
};
