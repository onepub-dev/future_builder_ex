# future_builder_ex

Provides an easier to use verion of FutureBuilder.

Usage of FutureBuilderEx must use the same rules that apply to FutureBuilder:


The [future] must not be created during the State.build or StatelessWidget.build method call when constructing the FutureBuilder. 
If the future is created at the same time as the FutureBuilder, then every time the FutureBuilder's parent is rebuilt, the asynchronous task will be restarted.

### future
The [future] parameter takes a function that must return a Future.
We guarentee to only call the [future] function once.

However, if you cause the FutureBuilderEx to be recreated (e.g. you pop a page 
than navigate back to the page) then the future will be called once again.
If you have a [future] that must only ever be called once then the future
should be tied to your top level application widget.

Your future function may contain multiple awaits:

```dart
        FutureBuilderEx<String>(
            future: () => selectedTeam.teamName,
            builder: (context, teamName) 
                => Text('Team: $teamName', color: Colors.white),
            stackTrace: Trace.current(),
      ),
    );
```


## Builders
FutureBuilderEx allows you to provide three builders. The [waitingBuilder] 
and [errorBuilder] are optional but we recommend that you provide the
[waitingBuilder] at the minimum unless you future always completes quickly 
(less than 500ms).

### waitingBuilder
waitingBuilder - called whenever the render tree needs to be built
 and the [future] has not yet completed.
If you don't provide a [waitingBuilder] then we display a default
'Loading...' textblock centered in the screen until the [future] completes.
We only show the 'Loading...' indicator if the the [future] takes longer than
500ms to complete. For the first 500ms we show a empty screen as this helps
to reduce flicker when the [future] completes quickly.

### builder

builder - called whenever the render tree needs to be built and the [future]
has completed.

### errorBuilder
errorBuilder - called whenever the render tree needs to be built after
the [future] returns an error.

If you don't provide an [errorBuilder] and the future throws an error then
a generic message 'An error occured: XXXX' will be displayed.



### stack repair
When the future returns an error FutureBuilderEx performs a stack repair on the
async call so that you get a clean stack trace showing where the 
FutureBuilderEx was created from and where the error was thrown from.
Errors ar



## Usage


 ```dart
 Widget build(BuildContext contect) {
  return Consumer<SelectedTeam>(
      builder: (context, selectedTeam, _) 
        => FutureBuilderEx<String>(
            future: () => selectedTeam.teamName,
            waitingBuilder: (context) => Text('Loading'),
            builder: (context, teamName) 
                => Text('Team: $teamName', color: Colors.white),
            errorBuilder:
            stackTrace: StackTraceImpl(),
      ),
    );
 }
 ```
