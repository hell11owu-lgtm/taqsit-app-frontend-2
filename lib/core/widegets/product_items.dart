import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:installment/core/theme/app_text_style.dart';
import 'package:installment/features/favorites/bloc/favorite_bloc.dart';
import 'package:installment/features/favorites/bloc/favorite_event.dart';
import 'package:installment/features/favorites/bloc/favorite_state.dart';
import 'package:installment/features/home/presentation/pages/product_details_page.dart';
import '../../features/home/data/model/product_model.dart';

class ProductItems extends StatelessWidget {
  final ProductModel product;

  const ProductItems({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => ProductDetailsPage(product: product),
          ),
        );
      },
      child: Container(
        width: 150,
        padding: EdgeInsets.all(0),
        margin: const EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: const Color.fromARGB(255, 255, 255, 255),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Expanded(
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 238, 238, 237),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: product.image.isEmpty
                            // إذا كان الرابط فارغاً نعرض الصورة البديلة
                            ? Image.asset(
                                'assets/images/img2.png',
                                fit: BoxFit.cover,
                              )
                            // فحص: هل الرابط قادم من الإنترنت (http)؟
                            : product.image.startsWith('http')
                            ? Image.network(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/img2.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              )
                            // إذا كان الرابط لا يبدأ بـ http (مثل مسار assets محلي من قاعدة البيانات)
                            : Image.asset(
                                product.image,
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) {
                                  return Image.asset(
                                    'assets/images/img2.png',
                                    fit: BoxFit.cover,
                                  );
                                },
                              ),
                      ),
                    ),
                  ),

                  Positioned(
                    top: 6,
                    right: 6,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: BlocBuilder<FavoritesBloc, FavoritesState>(
                        builder: (context, state) {
                          final isFavorite = state.favorites.any(
                            (item) => item.id == product.id,
                          );

                          return GestureDetector(
                            onTap: () {
                              if (isFavorite) {
                                context.read<FavoritesBloc>().add(
                                  RemoveFromFavorites(product),
                                );
                              } else {
                                context.read<FavoritesBloc>().add(
                                  AddToFavorites(product),
                                );
                              }
                            },
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: isFavorite ? Colors.red : Colors.black,
                              size: 18,
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(product.name, style: AppTextStyles.productPrice3),
            SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text("ريال ", style: AppTextStyles.productPrice2),
                Text("${product.price}", style: AppTextStyles.productPrice2),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
