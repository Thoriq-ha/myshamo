import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:myshamo/models/category_model.dart';
import '../models/message_model.dart';
import '../models/product_model.dart';
import '../models/user_model.dart';

class MessageService {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Stream<List<MessageModel>> getMessagesByUserId({required int userId}) {
    try {
      return firestore
          .collection('messages')
          .where('userId', isEqualTo: userId)
          .snapshots()
          .map((QuerySnapshot list) {
        var result = list.docs.map<MessageModel>((DocumentSnapshot message) {
          print(message.data());
          // return MessageModel.fromJson(message.data());
          return MessageModel(
              message: '',
              userId: userId,
              userName: '',
              userImage: '',
              isFromUser: false,
              product: ProductModel(
                  id: 0,
                  name: '',
                  price: 0,
                  description: '',
                  tags: '',
                  category: CategoryModel(id: 0, name: ''),
                  createdAt: DateTime(2021),
                  updatedAt: DateTime(2021),
                  galleries: []),
              createdAt: DateTime(2021),
              updatedAt: DateTime(2021));
        }).toList();

        result.sort(
          (MessageModel a, MessageModel b) =>
              a.createdAt.compareTo(b.createdAt),
        );

        return result;
      });
    } catch (e) {
      throw Exception(e);
    }
  }

  Future<void> addMessage(
      {required UserModel user,
      required bool isFromUser,
      required String message,
      required ProductModel product}) async {
    try {
      firestore.collection('messages').add({
        'userId': user.id,
        'userName': user.name,
        'userImage': user.profilePhotoUrl,
        'isFromUser': isFromUser,
        'message': message,
        'product': product is ProductModel ? {} : product.toJson(),
        'createdAt': DateTime.now().toString(),
        'updatedAt': DateTime.now().toString(),
      }).then(
        (value) => print('Pesan Berhasil Dikirim!'),
      );
    } catch (e) {
      throw Exception('Pesan Gagal Dikirim!');
    }
  }
}
