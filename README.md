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
        FutureBuilderEx<Team>(
            future: () => selectedTeam,
            initData: "Select Team",
            waitBuilder: (context) => Text('Loading'),
            errorBuilder: (error) => Text(error),
            builder: (context, team) 
                => Text('Team: ${team.name}', color: Colors.white),
      ),
    );
```


# Sponsored by OnePub
Help support FutureBuilderEx by supporting [OnePub](https://onepub.dev), the private dart repository.
OnePub allows you to privately share dart packages between your own projects or with colleagues.
Try it for free and publish your first private package in seconds.

https://onepub.dev

Publish a private package in six commands:
```bash
dart pub global activate onepub
onepub login
flutter create -t package mypackage
cd mypackage
onepub pub private
dart pub publish
```
You can now add your private package to any app
```bash
onepub pub add mypackage
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


## Usage


 ```dart
 Widget build(BuildContext contect) {
  return Consumer<SelectedTeam>(
      builder: (context, selectedTeam, _) 
        => FutureBuilderEx<SelectedTeam>(
            future: () => selectedTeam,
            waitingBuilder: (context) => Text('Select your favourite team'),
            builder: (context, teamName) 
                => Text('Selected Team: ${team.name}', color: Colors.white),
            errorBuilder: (error) => Text('Oops: $error')
      ),
    );
 }
 ```
