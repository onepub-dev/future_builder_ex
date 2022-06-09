/* Copyright (C) S. Brett Sutton - All Rights Reserved
 * Unauthorized copying of this file, via any medium is strictly prohibited
 * Proprietary and confidential
 * Written by Brett Sutton <bsutton@onepub.dev>, Jan 2022
 */


import 'package:flutter/cupertino.dart';

/// A convenience widget that returns a container
/// that has zero height and zero width.
class Empty extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 0, height: 0);
  }
}
