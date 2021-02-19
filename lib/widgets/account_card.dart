import 'package:biblionantes/models/SummeryAccount.dart';
import 'package:biblionantes/widgets/summary_account.dart';
import 'package:flutter/material.dart';

class AccountCard extends StatelessWidget {
  final Account account;

  const AccountCard({Key key, @required this.account})
      : assert(account != null),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      padding: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            offset: const Offset(0.0, 1.0),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            child: Icon(Icons.supervised_user_circle),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(account.name),
                  Text(account.login),
                  SummaryAccountCard(account: account)
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
