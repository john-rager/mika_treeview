import 'package:mika_treeview/mika_treeview.dart';

final Tree tree = [
  {
    'id': '1',
    'name': 'Sales',
  },
  {
    'id': '2',
    'name': 'Accounting',
    'children': [
      {
        'id': '5',
        'name': 'Payroll',
      },
      {
        'id': '3',
        'name': 'Accounts Payable',
      },
      {
        'id': '4',
        'name': 'Accounts Receivable',
      },
    ]
  },
  {
    'id': '6',
    'name': 'Manufacturing',
    'children': [
      {
        'id': '7',
        'name': 'Product Design',
        'children': [
          {
            'id': '8',
            'name': 'Research & Development',
          }
        ],
      },
    ]
  },
];
