import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';

class ImageCarousel extends StatefulWidget {
  final List<String> imageUrls;
  final double height;

  const ImageCarousel({
    super.key,
    required this.imageUrls,
    this.height = 300,
  });

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.imageUrls.isEmpty) {
      return Container(
        height: widget.height,
        width: double.infinity,
        color: AppColors.inputFill,
        child: const Icon(Icons.image_not_supported, size: 50, color: AppColors.secondaryText),
      );
    }

    return Stack(
      children: [
        SliverImageContainer(
          height: widget.height,
          child: PageView.builder(
            controller: _pageController,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemCount: widget.imageUrls.length,
            itemBuilder: (context, index) {
              return Image.network(
                widget.imageUrls[index],
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: AppColors.inputFill,
                    child: const Icon(Icons.error_outline, color: AppColors.error),
                  );
                },
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return Center(
                    child: CircularProgressIndicator(
                      value: loadingProgress.expectedTotalBytes != null
                          ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                          : null,
                      color: AppColors.primaryBlue,
                    ),
                  );
                },
              );
            },
          ),
        ),
        
        // Dot Indicator
        if (widget.imageUrls.length > 1)
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.imageUrls.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  height: 8,
                  width: _currentPage == index ? 24 : 8,
                  decoration: BoxDecoration(
                    color: _currentPage == index 
                        ? Colors.white 
                        : Colors.white.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          
        // Back Button Overlay (Common in detail screens)
        Positioned(
          top: MediaQuery.of(context).padding.top + 10,
          left: 16,
          child: CircleAvatar(
            backgroundColor: Colors.white.withValues(alpha: 0.9),
            child: IconButton(
              icon: const Icon(Icons.arrow_back, color: AppColors.primaryText),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ),
        ),
      ],
    );
  }
}

/// A simple helper to provide consistent rounding/clipping if needed
class SliverImageContainer extends StatelessWidget {
  final Widget child;
  final double height;

  const SliverImageContainer({
    super.key,
    required this.child,
    required this.height,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: child,
    );
  }
}
