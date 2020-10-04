import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rxdart/rxdart.dart';

class UserBloc extends BlocBase {
      final _usersController = BehaviorSubject<List>();
     
      Stream<List> get outUsers => _usersController.stream;
     
      Map<String, Map<String, dynamic>> _users = {};
     
      Firestore _firestore = Firestore.instance;
     
      UserBloc() {
        loadUsers();
      }
     
      /*void onChangedSearch(String search) {
        if (search.trim().isEmpty) {
          _usersController.add(_users.values.toList());
        } else {
          _usersController.add(_filter(search.trim()));
        }
      }
     
      List<Map<String, dynamic>> _filter(String search) {
        List<Map<String, dynamic>> filteredUsers =
            List.from(_users.values.toList());
        filteredUsers.retainWhere((user) {
          return user["name"].toUpperCase().contains(search.toUpperCase());
        });
        return filteredUsers;
      }*/
     
      void loadUsers() async {
        _users.clear();
     
        _firestore.collection("users").getDocuments().then((queryUsers) {
          queryUsers.documents.forEach((user) {
            String uid = user.documentID;
     
            _users[uid] = user.data;
     
            _loadOrders(uid);
          });
        });
      }
     
      void _loadOrders(String uid) async {
        _firestore
            .collection("users")
            .document(uid)
            .collection("ordersDelicia")
            .snapshots()
            .listen((orders) async {
          int numOrders = orders.documents.length;
     
          double money = 0.0;
     
          for (DocumentSnapshot d in orders.documents) {
            DocumentSnapshot order =
                await _firestore.collection("ordersDelicia").document(d.documentID).get();
     
            if (order.data == null) continue;
     
            money += order.data["totalPrice"];
          }
     
          _users[uid].addAll({"money": money, "ordersDelicia": numOrders});
     
          _usersController.add(_users.values.toList());
        });
      }
     
      Map<String, dynamic> getUser(String uid) {
        return _users[uid];
      }
     
      @override
      void dispose() {
        _usersController.close();
      }
    }