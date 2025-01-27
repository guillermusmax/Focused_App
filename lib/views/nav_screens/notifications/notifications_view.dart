import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:focused_app/constants.dart';
import 'package:focused_app/generated/l10n.dart';
import 'package:focused_app/api/state_models.dart';

class NotificationSidebarScreen extends StatefulWidget {
  const NotificationSidebarScreen({Key? key}) : super(key: key);

  @override
  _NotificationSidebarScreenState createState() => _NotificationSidebarScreenState();
}

class _NotificationSidebarScreenState extends State<NotificationSidebarScreen> {
  @override
  void initState() {
    super.initState();
    _refreshNotifications();
  }

  void _refreshNotifications() {
    final notificationProvider = Provider.of<NotificationProvider>(context, listen: false);
    //print('Llamando a fetchNotifications desde _refreshNotifications...');
    notificationProvider.fetchNotifications().then((_) {
      //print('Notificaciones cargadas después de fetchNotifications: ${notificationProvider.notifications}');
    });
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final notifications = Provider.of<NotificationProvider>(context).notifications;
    final isLoading = Provider.of<NotificationProvider>(context).isLoading;

    return Scaffold(
      backgroundColor: Colors.black.withOpacity(0.5),
      body: Row(
        children: [
          GestureDetector(
            onTap: () => Navigator.of(context).pop(),
            child: Container(
              color: Colors.transparent,
              width: size.width * 0.25,
              height: size.height,
            ),
          ),
          Container(
            width: size.width * 0.75,
            height: size.height,
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: const BorderRadius.only(
                topLeft: Radius.circular(16.0),
                bottomLeft: Radius.circular(16.0),
              ),
            ),
            child: Column(
              children: [
                // Header
                Container(
                  color: secondaryColor,
                  padding: const EdgeInsets.only(
                    top: 45.0,
                    bottom: 16.0,
                    left: 16.0,
                    right: 16.0,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          S.current.notifications,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: size.width * 0.05,
                            fontWeight: FontWeight.bold,
                            overflow: TextOverflow.ellipsis,
                          ),
                          maxLines: 1,
                        ),
                      ),
                      Row(
                        children: [
                          IconButton(
                            icon: const Icon(Icons.refresh, color: Colors.white),
                            onPressed: () {
                              Provider.of<NotificationProvider>(context, listen: false).fetchNotifications();
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close, color: Colors.white),
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Body
                Expanded(
                  child: isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : notifications.isEmpty
                      ? Center(
                    child: Text(
                      S.current.noNotifications,
                      style: const TextStyle(color: textSecondaryColor),
                    ),
                  )
                      : ListView.builder(
                    itemCount: notifications.length,
                    itemBuilder: (context, index) {
                      final notification = notifications[index];
                      return GestureDetector(
                        onTap: () {
                          if (notification['navigation'] != null) {
                            Navigator.pushNamed(
                              context,
                              notification['navigation'],
                              arguments: notification,
                            );
                          }
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 8.0,
                            horizontal: 16.0,
                          ),
                          padding: const EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                            color: secondaryColor,
                            borderRadius: BorderRadius.circular(12.0),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.notifications,
                                color: highlightColor,
                                size: 24.0,
                              ),
                              const SizedBox(width: 16.0),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      notification['title'],
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 16.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 4.0),
                                    Text(
                                      notification['details'],
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontSize: 14.0,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
