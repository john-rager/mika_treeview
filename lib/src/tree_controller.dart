import 'package:flutter_simple_treeview/flutter_simple_treeview.dart' as fst;

/// A controller for tree state.
///
/// This is a straight extend of flutter_simple_treeview's controller, simply
/// to save the consumer from having to import both mika_treeview and
/// flutter_simple_treeview.
class TreeController extends fst.TreeController {
  TreeController({bool allNodesExpanded = true})
      : super(allNodesExpanded: allNodesExpanded);
}
