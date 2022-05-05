import 'package:flutter_test/flutter_test.dart';
import 'package:mika_treeview/mika_treeview.dart';

void main() {
  group('Tree', () {
    test('loads from flat data', () {
      final List<Map<String, dynamic>> flatData = [
        {'id': 1, 'name': 'Accounting', 'parent_id': null},
        {'id': 4, 'name': 'Payroll', 'parent_id': 1},
        {'id': 5, 'name': 'Sales', 'parent_id': null},
        {'id': 6, 'name': 'Manufacturing', 'parent_id': null},
        {'id': 7, 'name': 'Product Design', 'parent_id': 6},
        {'id': 8, 'name': 'Lead Generation', 'parent_id': 5},
        {'id': 9, 'name': 'Research & Development', 'parent_id': 7},
        {'id': 3, 'name': 'Accounts Payable', 'parent_id': 1},
        {'id': 11, 'name': 'Parts Inventory', 'parent_id': 10},
        {'id': 2, 'name': 'Accounts Receivable', 'parent_id': 1},
        {'id': 10, 'name': 'Logistics', 'parent_id': 6}
      ];

      expect(Tree.fromFlat(flatData).nodes.length, 3);
    });
  });
}
