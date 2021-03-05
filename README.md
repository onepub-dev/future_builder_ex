# future_builder_ex

Provides an easier to use verion of FutureBuilder.



## Usage


 ```dart
 Widget build(BuildContext contect) {
  return Consumer<SelectedTeam>(
      builder: (context, selectedTeam, _) 
        => FutureBuilderEx<String>(
            future: () => selectedTeam.teamName,
            builder: (context, teamName) 
                => Text('Team: $teamName', color: Colors.white),
            stackTrace: StackTraceImpl(),
      ),
    );
 }
 ```
