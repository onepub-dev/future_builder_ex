# 5.0.0
BREAKING:
- removed the type from WaitingBuilder as it is not used.
- upgraded to lint_hard 5.0
- added leadingPadding to match other fields.

# 4.0.0
- BREAKING the 'future' argument to FutureBuilderEx is now a Future rather than
a function that returns a futre.  This is to fix a bug where
the builder wouldn't rebuild when the future is replaced.

# 3.1.0
- completed dart 3.x upgrade.
- upgraded logger.

# 3.0.0
- upgraded to dart 3.x

# 2.1.1
- Fixed the readme.
- lint fixes.

# 2.1.0
- restored the future parameter to be a function rather than a future as the future needs to be a call back. Resolved the problem of calling the future multiple times by calling it once in initState and then saving the resulting future. Fixed the error handling logic so that the errorBuilder is called as expected.

# 2.0.0
- FIXED: future_builder_ex was call the passed future function multiple times.  We changed the signature to just take a future so it is called only once during initialisation of the future builder .

# 1.1.3
- Fixed a bug were an exception is thrown when the initialData was null.

# 1.1.2
- Improved the stack trace we log when we the builder throws.

# 1.1.1
- BUG: fixed call to Logger().d as we were passing the stacktrace as the wrong argument.
- removed the linux and web directories as we have no platform specific code.
- remove the android and ios directories as we don't have any platform specific code so they are not needed. Exported StrackTraceImpl as its required by the api.

# 1.1.0
Removed the android and ios directories as we have no platform specific code.
Exported StackTraceImpl
# 1.0.0
Merge pull request #1 from bsutton/add-license-1
Create LICENSE

# 1.0.0
Added repository.

# 1.0.0
Added minimal documentation.
First commit

