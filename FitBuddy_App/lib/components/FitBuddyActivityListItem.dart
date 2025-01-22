import 'package:fit_buddy/components/FitBuddyButton.dart';
import 'package:fit_buddy/constants/color_constants.dart';
import 'package:fit_buddy/models/FitBuddyActivityModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class FitBuddyActivityListItem extends StatefulWidget {
  final Activity exercise;
  final Function onRemove;
  final Function onAddSet;
  final Function update;

  const FitBuddyActivityListItem({
    super.key,
    required this.exercise,
    required this.onRemove,
    required this.onAddSet,
    required this.update,
  });

  @override
  State<FitBuddyActivityListItem> createState() =>
      _FitBuddyActivityListItemState();
}

class _FitBuddyActivityListItemState extends State<FitBuddyActivityListItem> {
  final weightController = TextEditingController();
  bool _deleteMode = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            SizedBox(
                width: 100,
                child: Text(
                  widget.exercise.name,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )),
            _deleteMode
                ? FitBuddyButton(
                    text: "Delete sets",
                    onPressed: () {
                      // Iterate through the set collections and remove those with deleteSet set to true
                      widget.exercise.setCollection.removeWhere(
                          (setCollection) => setCollection.deleteSet);
                      _deleteMode = false;
                      widget.update();
                    },
                    fontSize: 14,
                  )
                : FitBuddyButton(
                    text: "Add set",
                    onPressed: () {
                      widget.onAddSet();
                    },
                    fontSize: 14,
                  ),
            const Spacer(),
            IconButton(
                icon: const Icon(Icons.more_vert),
                onPressed: () {
                  showModalBottomSheet<void>(
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (BuildContext context) {
                      return Container(
                        padding: const EdgeInsets.all(20),
                        height: 200,
                        decoration: BoxDecoration(
                          color: FitBuddyColorConstants.lSecondary,
                          borderRadius: const BorderRadius.only(
                            topLeft: Radius.circular(20),
                            topRight: Radius.circular(20),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Text(
                              widget.exercise.name,
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            const Divider(),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                widget.onRemove();
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.delete),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Delete exercise"),
                                ],
                              ),
                            ),
                            const Divider(),
                            GestureDetector(
                              behavior: HitTestBehavior.opaque,
                              onTap: () {
                                setState(() {
                                  _deleteMode = !_deleteMode;
                                });
                                Navigator.pop(context);
                              },
                              child: const Row(
                                children: [
                                  Icon(Icons.check_box_outlined),
                                  SizedBox(
                                    width: 10,
                                  ),
                                  Text("Select sets to delete"),
                                ],
                              ),
                            ),
                            const Divider(),
                          ],
                        ),
                      );
                    },
                  );
                }),
          ],
        ),
        const SizedBox(height: 10),
        // add a row for every entry in exercise.sets
        for (var setCollection in widget.exercise.setCollection)
          /*
          SetCollectionRow(onRemove: () {
            widget.exercise.setCollection.remove(setCollection);
          }, onUpdate: widget.update(), setCollection: setCollection, deleteMode: _deleteMode),
          */
          setCollectionRow(setCollection),
        const SizedBox(height: 10),
      ],
    );
  }

  Widget setCollectionRow(SetCollection setCollection) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    if (setCollection.sets == 0) {
                      widget.exercise.setCollection.remove(setCollection);
                      if (widget.exercise.setCollection.isEmpty) {
                        widget.onRemove();
                      }
                    }
                    setCollection.decrementSets();
                    widget.update();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove,
                  ),
                  constraints: const BoxConstraints(),
                ),
                Column(children: [
                  const Text("sets"),
                  const SizedBox(height: 10),
                  Text(setCollection.sets.toString()),
                ]),
                IconButton(
                  onPressed: () {
                    setCollection.incrementSets();
                    widget.update();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  onPressed: () {
                    setCollection.decrementReps();
                    widget.update();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(
                    Icons.remove,
                  ),
                  constraints: const BoxConstraints(),
                ),
                Column(children: [
                  const Text("reps"),
                  const SizedBox(height: 10),
                  Text(setCollection.reps.toString()),
                ]),
                IconButton(
                  onPressed: () {
                    setCollection.incrementReps();
                    widget.update();
                  },
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add),
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
          ),
          Expanded(
            child: Column(children: [
              const Text("weight"),
              SizedBox(
                height: 30,
                width: 70,
                child: TextFormField(
                  initialValue: '0',
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.all(0),
                  ),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'^\d{0,4}(\.\d{0,2})?$'),
                        replacementString: '9999.99'),
                  ],
                  onChanged: (value) {
                    if (value != "") {
                      double parsedValue = double.parse(value);
                      setCollection.weight = parsedValue;
                      widget.update();
                    }
                  },
                ),
              ),
            ]),
          ),
          !_deleteMode
              ? const SizedBox(
                  width: 40,
                )
              : IconButton(
                  onPressed: () {
                    setState(() {
                      setCollection.deleteSet = !setCollection.deleteSet;
                    });
                  },
                  icon: setCollection.deleteSet
                      ? const Icon(Icons.check_box_outlined)
                      : const Icon(Icons.check_box_outline_blank),
                  constraints: const BoxConstraints(),
                ),
        ],
      ),
    );
  }
}
