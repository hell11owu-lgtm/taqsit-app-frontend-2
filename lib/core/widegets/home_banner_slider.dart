import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:installment/core/theme/app_buttons.dart';
import 'package:installment/core/theme/app_text_style.dart';
// import 'package:installment/features/home/data/banner_list.dart';
class HomeBannerSlider extends StatelessWidget {
  final List banners;

  const HomeBannerSlider({
    super.key,
    required this.banners,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 180,
      child: CarouselSlider.builder(
        itemCount: banners.length,
        itemBuilder: (context, index, realIndex) {
          final banner = banners[index];

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    banner.image,
                    fit: BoxFit.cover,
                  ),

                  Container(
                    color: Colors.black.withOpacity(0.1),
                  ),

                  Positioned(
                    top: 20,
                    right: 20,
                    left: 150,
                    child: Text(
                      banner.title,
                      textAlign: TextAlign.right,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.bannerTitle,
                    ),
                  ),

                  Positioned(
                    bottom: 12,
                    right: 14,
                    child: ElevatedButton.icon(
                      style: AppButtons.smallRounded,
                      icon: const Icon(Icons.keyboard_arrow_right_sharp,color:  Color.fromARGB(255, 93, 16, 194),),
                      onPressed: () {
                        // navigation here
                      },
                      label: const Text("تسوق الان",style: AppTextStyles.buttonsmalltext,),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
        options: CarouselOptions(
          height: 180,
          viewportFraction: 1.0,
          autoPlay: true,
          autoPlayInterval: const Duration(seconds: 6),
          autoPlayAnimationDuration: const Duration(seconds: 1),
          enableInfiniteScroll: true,
        ),
      ),
    );
  }
}