import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import 'package:flutter/material.dart';

import '../models/FitBuddyActivityModel.dart';
import '../models/FitBuddyPostModel.dart';

class FitBuddyTimelinePost extends StatefulWidget {
  final Post postData;

  const FitBuddyTimelinePost({super.key, required this.postData});

  @override
  _FitBuddyTimelinePostState createState() => _FitBuddyTimelinePostState();
}

class _FitBuddyTimelinePostState extends State<FitBuddyTimelinePost> {
  bool _showAllActivities = false;

  String formatDateForDisplay(Timestamp timestamp) {
    final currentDate = DateTime.now();
    final postDate = timestamp.toDate();
    final difference = currentDate.difference(postDate);

    if (difference.inMinutes < 60) {
      return '${difference.inMinutes}m';
    } else if (difference.inHours < 24) {
      return '${difference.inHours}h';
    } else if (difference.inDays <= 5) {
      return '${difference.inDays}d';
    } else {
      return '${postDate.month}/${postDate.day}';
    }
  }

  @override
  Widget build(BuildContext context) {
    var activities = widget.postData.workout;
    if (!_showAllActivities && activities.length > 2) {
      activities = activities.sublist(0, 2);
    }
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        // This is to go to a single post page
        // context.goNamed(FitBuddyRouterConstants.singlePostPage, pathParameters: {'postId': widget.postData.postId});
      },
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Profile header
                profileHeader(),
                const SizedBox(height: 10),
                // if no description, or description is empty don't show
                ...(widget.postData.description != "")
                    ? [
                        Text(widget.postData.description,
                            style: const TextStyle(
                                fontWeight: FontWeight.w500, fontSize: 16)),
                      ]
                    : [],
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: activities.map<Widget>((activityData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 10),
                        // Activity name
                        Text(activityData.name,
                            style: const TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 18)),
                        const SizedBox(height: 5),
                        // Row containing three columns
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.6,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Column for reps
                              buildDetailColumn(
                                  "reps", activityData.setCollection),
                              // Column for sets
                              buildDetailColumn(
                                  "sets", activityData.setCollection),
                              // Column for weight
                              buildDetailColumn(
                                  "weight", activityData.setCollection),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                const SizedBox(height: 10),
                if (!_showAllActivities && widget.postData.workout.length > 2)
                  SizedBox(
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _showAllActivities = true;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
                if (_showAllActivities && widget.postData.workout.length > 2)
                  SizedBox(
                    height: 24,
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      onPressed: () {
                        setState(() {
                          _showAllActivities = false;
                        });
                      },
                      icon: const Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                //SizedBox(height: 10),
              ],
            ),
          ),
          Divider(thickness: 2, color: FitBuddyColorConstants.lAccent),
        ],
      ),
    );
  }

  Widget buildDetailColumn(String label, List<SetCollection> activityData) {
    return Column(
      children: [
        Text(label,
            style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 16,
                color: FitBuddyColorConstants.lOnSecondary)),
        ...activityData
            .map<Widget>((detail) => Padding(
                padding: const EdgeInsets.only(top: 5),
                child: Text(detail.getProperty(label).toString(),
                    style: const TextStyle(fontSize: 14))))
            .toList(),
      ],
    );
  }

  Widget profileHeader() {
    return SizedBox(
      height: 40,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(widget.postData.user.image ?? ""),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Column(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(widget.postData.user.name! ?? "",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 18)),
              Text(formatDateForDisplay(widget.postData.timestamp),
                  style: TextStyle(
                      fontWeight: FontWeight.w100,
                      fontSize: 12,
                      color: FitBuddyColorConstants.lOnSecondary)),
            ],
          ),
        ],
      ),
    );
  }
}
