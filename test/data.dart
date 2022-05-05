import 'package:mika_treeview/mika_treeview.dart';

final Tree tree = Tree(
  nodes: [
    Node(
      id: '1',
      name: 'Sales',
    ),
    Node(
      id: '2',
      name: 'Accounting',
      children: [
        Node(
          id: '5',
          name: 'Payroll',
        ),
        Node(
          id: '3',
          name: 'Accounts Payable',
        ),
        Node(
          id: '4',
          name: 'Accounts Receivable',
        ),
      ],
    ),
    Node(
      id: '6',
      name: 'Manufaturing',
      children: [
        Node(
          id: '7',
          name: 'Product Design',
          children: [
            Node(
              id: '8',
              name: 'Research & Development',
            ),
          ],
        ),
      ],
    ),
  ],
);
