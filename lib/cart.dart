//
//
// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
//
// import 'Models/itemsModel.dart';
// import 'billDetails.dart';
//
// class CartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(context.watch<Items>().itemName! + 's Cart'),
//       ),
//       body: Consumer<Cart>(
//         builder: (BuildContext context, Cart cart, Widget? child) {
//           return Column(
//             children: <Widget>[
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: cart.products.length,
//                   itemBuilder: (BuildContext context, int index) {
//                     if (cart.products.isEmpty) {
//                       return Text('no products in cart');
//                     }
//                     final item = cart.products[index];
//                     return ListTile(
//                       title: Text(item.itemName ?? ''),
//                       subtitle: Text('cost: ${item.salesprice.toString() ?? 'free'}'),
//                       trailing: Text('tap to remove from cart'),
//                       onTap: () {
//                         context.read<Cart>().removeFromCart(item);
//                       },
//                     );
//                   },
//                 ),
//               ),
//               Divider(),
//               Align(
//                 alignment: Alignment.centerRight,
//                 child: Text(
//                   'TOTAL: ${context.select((Cart c) => c.total)}',
//                   style: Theme.of(context).textTheme.headline3,
//                 ),
//               )
//             ],
//           );
//         },
//       ),
//     );
//   }
// }