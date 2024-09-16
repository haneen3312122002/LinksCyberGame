import 'package:flutter/material.dart';
import 'Block.dart'; // Import Block class

class WallArea extends StatefulWidget {
  final List<Block> correctPassword;
  final double wallHeight;
  final bool isDrawerVisible; // حالة القائمة لمعرفة إذا كانت مرئية أم لا

  WallArea({
    required this.correctPassword,
    required this.wallHeight,
    required this.isDrawerVisible,
  });

  @override
  _WallAreaState createState() => _WallAreaState();
}

class _WallAreaState extends State<WallArea> {
  Map<int, Block> droppedBlocks = {};

  @override
  Widget build(BuildContext context) {
    double blockWidth =
        MediaQuery.of(context).size.width / (widget.isDrawerVisible ? 8 : 6);
    double blockHeight = widget.wallHeight / 4;

    return Container(
      margin: EdgeInsets.only(bottom: 10),
      width: double.infinity,
      height: widget.wallHeight,
      color: Colors.transparent,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(4, (rowIndex) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildFixedBlock(blockWidth, blockHeight),
              _buildFixedBlock(blockWidth, blockHeight),
              ..._buildBlocksForRow(
                  rowIndex * 2, (rowIndex + 1) * 2, blockWidth, blockHeight),
              _buildFixedBlock(blockWidth, blockHeight),
              _buildFixedBlock(blockWidth, blockHeight),
            ],
          );
        }),
      ),
    );
  }

  List<Widget> _buildBlocksForRow(
      int start, int end, double blockWidth, double blockHeight) {
    List<Widget> rowBlocks = [];
    for (int i = start; i < end; i++) {
      if (droppedBlocks.containsKey(i)) {
        rowBlocks.add(
            _buildDroppedBlock(droppedBlocks[i]!, blockWidth, blockHeight));
      } else {
        rowBlocks.add(_buildDropTarget(i, blockWidth, blockHeight));
      }
    }
    return rowBlocks;
  }

  Widget _buildFixedBlock(double blockWidth, double blockHeight) {
    return Container(
      width: blockWidth - 4, // Reduced margin for tighter spacing
      height: blockHeight,
      decoration: BoxDecoration(
        color: Colors.brown,
        border: Border.all(color: Colors.black, width: 4.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(6, 6))
        ],
      ),
    );
  }

  Widget _buildDroppedBlock(
      Block block, double blockWidth, double blockHeight) {
    return Container(
      width: blockWidth - 4, // Reduced margin for tighter spacing
      height: blockHeight,
      decoration: BoxDecoration(
        color: Colors.brown,
        border: Border.all(color: Colors.black, width: 4.0),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.5),
              spreadRadius: 2,
              blurRadius: 6,
              offset: Offset(6, 6))
        ],
      ),
      child: Center(
        child: Text(block.text,
            style: TextStyle(color: Colors.white, fontSize: 13)),
      ),
    );
  }

  Widget _buildDropTarget(int index, double blockWidth, double blockHeight) {
    return DragTarget<Block>(
      onAccept: (block) {
        setState(() {
          droppedBlocks[index] = block;
        });
      },
      builder: (context, candidateData, rejectedData) {
        return Container(
          width: blockWidth - 4, // Increased drop target area
          height: blockHeight,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey, width: 2.0),
          ),
        );
      },
    );
  }
}
