import 'package:fit_buddy/models/FitBuddyActivityModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SetCollectionRow extends StatefulWidget {
  final Function onRemove;
  final Function onUpdate;
  final SetCollection setCollection;
  bool deleteMode;

  SetCollectionRow({
    super.key,
    required this.onRemove,
    required this.onUpdate,
    required this.setCollection,
    required this.deleteMode,
  });

  @override
  State<SetCollectionRow> createState() => _SetCollectionRowState();
}

class _SetCollectionRowState extends State<SetCollectionRow>{

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              IconButton(onPressed: () {
                if (widget.setCollection.sets == 0) {
                  widget.onRemove();
                }
                widget.setCollection.decrementSets();
                widget.onUpdate();
              }, icon: const Icon(Icons.remove, ), constraints: const BoxConstraints(),),
              Column(
                  children: [
                    const Text("sets"),
                    const SizedBox(height: 10),
                    Text(widget.setCollection.sets.toString()),
                  ]
              ),
              IconButton(onPressed: () {
                widget.setCollection.incrementSets();
                widget.onUpdate();
              }, icon: const Icon(Icons.add), constraints: const BoxConstraints(),),
            ],
          ),
          Row(
            children: [
              IconButton(onPressed: () {
                widget.setCollection.decrementReps();
                widget.onUpdate();
              }, icon: const Icon(Icons.remove, ), constraints: const BoxConstraints(),),
              Column(
                  children: [
                    const Text("reps"),
                    const SizedBox(height: 10),
                    Text(widget.setCollection.reps.toString()),
                  ]
              ),
              IconButton(onPressed: () {
                widget.setCollection.incrementReps();
                widget.onUpdate();
              }, icon: const Icon(Icons.add), constraints: const BoxConstraints(),),
            ],
          ),
          Column(
              children: [
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
                    keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'^\d{0,4}(\.\d{0,2})?$'), replacementString: '9999.99'),
                    ],
                    onChanged: (value) {
                      if (value != "") {
                        double parsedValue = double.parse(value);
                        widget.setCollection.weight = parsedValue;
                        widget.onUpdate();
                      }
                    },

                  ),
                ),
              ]
          ),
          !widget.deleteMode ? const SizedBox(width: 40,) :
          IconButton(onPressed: () {
            widget.deleteMode = !widget.deleteMode;
            if (widget.deleteMode) {
              print("delete set ${widget.deleteMode}");
            }
          }, icon: widget.deleteMode ? const Icon(Icons.check_box_outline_blank) : const Icon(Icons.check_box_outlined), constraints: const BoxConstraints(),),
        ],
      ),
    );
  }

}