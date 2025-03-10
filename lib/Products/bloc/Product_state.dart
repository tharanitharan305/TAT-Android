part of 'Product_bloc.dart';

abstract class ProductState extends Equatable {
  const ProductState();

  @override
  List<Object> get props => [];
}

class ProductError extends ProductState {
  final String message;

  const ProductError({required this.message});

  @override
  List<Object> get props => [message];
}

class ProductLoading extends ProductState {}

class ProductUpdating extends ProductState {}

class ProductLoaded extends ProductState {
  const ProductLoaded();
  @override
  List<Object> get props => [];
}

class ProductListReady extends ProductState {
  List<Product> product_list;
  ProductListReady({required this.product_list});
}
