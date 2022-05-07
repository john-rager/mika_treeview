A treeview based on [flutter_simple_treeview](https://pub.dev/packages/flutter_simple_treeview), adding several useful features.

<p>
    <img src="https://github.com/john-rager/mika_treeview/blob/main/doc/mika_treeview_ios.gif?raw=true"
    alt="An animated image of the iOS MIKA Tree View UI" height="600"/>
</p>

## Features

* Can accept an alternative widget to render if the tree is empty.
* Single or multiple nodes can be toggled as selected.
* The tree can be sorted alphabetically.
* The tree can be searched.
* A trailing widget can be attached to the nodes to provide for use
  cases such as providing a pop-up menu or a button to take action on a
  particular node.

## Getting started

Add `mika_treeview` as a dependency in your pubspec.yaml file.

```yaml
dependencies:
  mika_treeview: ^0.1.0
```
Add the following import to your .dart file:
```dart
import 'package:mika_treeview/mika_treeview.dart';
```

## Usage

The tree input must be provided as a `List<Map<String, dynamic>>`, for example:

```dart
Tree tree = [
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
```

NOTE: Often when pulling hierarchical data from a database table, it will look something like this:

|  id   |          name          | parent_id |
|:-----:|:----------------------:|:---------:|
|   1   |       Accounting       |    null   |
|   2   |   Accounts Receivable  |      1    |
|   3   |    Accounts Payable    |      1    |
|   4   |      Manufacturing     |    null   |
|   5   |      Product Design    |      4    |
|   6   | Research & Development |      5    |

\
To save from having to convert this into the structure required by TreeView, there is a factory method `Tree.fromFlat` that accepts this format and converts it to the required `Tree` structure. See the API documentation for more information.

Example tree view (all options enabled):

```dart
TreeView(
  tree: tree,
  treeController: _controller,
  selectMode: SelectMode.multiple,
  values: const {'1', '3'},
  onChanged: _onChangedHandler,
  emptyTreeNotice: const EmptyTreeWidget(),
  trailingBuilder: _trailingBuilder,
  isSearchable: true,
  isSorted: true,
  indent: 20.0,
),
```
See the API documentation for more information.

## Additional information

This is my very first package on pub.dev, so I'd love to hear your feedback. If you find it useful, please like it - it'll help
keep me motivated. If you have any suggestions or problems, please start a discussion or submit an issue to my [GitHub repo](https://github.com/john-rager/mika_treeview) and I'll do my very best to address it promptly.
