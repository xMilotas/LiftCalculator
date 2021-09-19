import 'package:charts_flutter/flutter.dart';
import 'package:flutter/material.dart';
import 'dart:math';
import 'package:charts_flutter/src/text_element.dart' as chartsTextElement;
import 'lift.dart';

class LiftChart extends StatefulWidget {
  final List<Series<dynamic, DateTime>> seriesList;
  final String liftTitle;
  final bool animate;

  LiftChart(this.seriesList, this.liftTitle, {this.animate = false});

  // We need a Stateful widget to build the selection details with the current
  // selection as the state.
  @override
  State<StatefulWidget> createState() => new _SelectionCallbackState();
}

class _SelectionCallbackState extends State<LiftChart> {
  Lift? lift;

  // Listens to the underlying selection changes, and updates the information
  // relevant to building the primitive legend like information under the
  // chart.
  _onSelectionChanged(SelectionModel model) {
    final selectedDatum = model.selectedDatum;
    Lift? selectedLift;

    if (selectedDatum.isNotEmpty) {
      selectedLift = selectedDatum.first.datum;
    }

    // Request a build.
    setState(() {
      lift = selectedLift;
    });
  }

  @override
  Widget build(BuildContext context) {
    // The children consist of a Chart and Text widgets below to hold the info.
    final children = <Widget>[
      new SizedBox(
          height: 150.0,
          child: new TimeSeriesChart(
            widget.seriesList,
            animate: widget.animate,
            behaviors: [
              new ChartTitle(widget.liftTitle,
                  titleStyleSpec: TextStyleSpec(color: MaterialPalette.white),
                  subTitle: 'Calculated 1RM',
                  behaviorPosition: BehaviorPosition.top,
                  titleOutsideJustification: OutsideJustification.start,
                  innerPadding: 18),
              SelectNearest(
                  eventTrigger: SelectionTrigger.tapAndDrag,
                  selectClosestSeries: true),
              LinePointHighlighter(
                  radiusPaddingPx: 3.0,
                  showVerticalFollowLine:
                      LinePointHighlighterFollowLineType.nearest,
                  // symbolRenderer:
                  //     MySymbolRenderer(MediaQuery.of(context).size)
                  ),
            ],
            selectionModels: [
              new SelectionModelConfig(
                type: SelectionModelType.info,
                changedListener: _onSelectionChanged,
              )
            ],
          )),
    ];

    return new Column(children: children);
  }
}

// class MySymbolRenderer extends CircleSymbolRenderer {
//   final Size size;
//   MySymbolRenderer(this.size);

//   @override
//   void paint(ChartCanvas canvas, Rectangle<num> bounds,
//       {List<int>? dashPattern,
//       Color? fillColor,
//       FillPatternType? fillPattern,
//       Color? strokeColor,
//       double? strokeWidthPx}) {
//     print("[CUSTOM DRAWER CALLED]: ");
//     final center = Point(
//       bounds.left + (bounds.width / 2),
//       bounds.top + (bounds.height / 2),
//     );
//     final radius = min(bounds.width, bounds.height) / 2;
//     canvas.drawPoint(
//         point: center,
//         radius: radius,
//         fill: getSolidFillColor(fillColor),
//         stroke: strokeColor,
//         strokeWidthPx: getSolidStrokeWidthPx(strokeWidthPx));
    
//       final TextElement textElement =
//           chartsTextElement.TextElement(lift!.weightRep.toString());
//       canvas.drawText(textElement, 150, 45);
//     }
//   }
// }
