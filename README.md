# Pre-Commit

[![License](https://img.shields.io/github/license/devkabiir/pre_commit.svg)][LICENSE]
[![Travis build](https://img.shields.io/travis/com/devkabiir/pre_commit.svg)][repo]
[![Commitizen friendly](https://img.shields.io/badge/commitizen-friendly-brightgreen.svg)][commitizen]
[![Commitizen style](https://img.shields.io/badge/commitizen--style-emoji-brightgreen.svg)][cz-emoji]

## About

pre_commit script to automate tedious tasks in dart

## Usage

Add `pre_commit` to `dev_dependencies`

```yaml
dev_dependencies:
  ...
  pre_commit:
    git: https://www.github.com/devkabiir/pre_commit
```

For non-flutter projects you can directly invoke it via

```sh
pub run pre_commit
```

For flutter projects you need to create a dart executable and call `preCommit()` method through it.

e.g. `<your-project>/bin/pre_commit.dart`

```dart
import 'package:pre_commit/pre_commit.dart';

void main() => preCommit();

// You can optionally specify working directory
// this defaults to the current working directory
void main() => preCommit(workingDirectory: '<path/to/project>');
```

and then run

```sh
dart bin/pre_commit.dart
```

## Contributing

- :fork_and_knife: Fork this repo
- Clone your forked version  
  `git clone https://github.com/<you>/pre_commit.git`

- :heavy_plus_sign: Add this repo as a remote  
  `git remote add upstream https://github.com/devkabiir/pre_commit.git`

- :arrow_double_up: Make sure you have recent changes  
  `git fetch upstream`

- :sparkles: Make a new branch with your proposed changes/fixes/additions  
  `git checkout upstream/master -b name_of_your_branch`

- :bookmark_tabs: Make sure you follow guidelines for [Git](#git)
- Push your changes  
  `git push origin name_of_your_branch`

- Make a pull request

## Git

- :white_check_mark: Sign all commits. Learn about [signing-commits]
- Use [commitizen] with [cz-emoji] adapter
- Check existing commits to get an idea
- Run the pre_commit script from project root `pub run pre_commit`
- If you're adding an `and` in your commit message, it should probably be separate commits
- Link relevant issues/commits with a `#` sign in the commit message
- Limit message length per line to 72 characters (excluding space required for linking issues/commits)
- Add commit description if message isn't enough for explaining changes

## Code style

- Maintain consistencies using included `.editorconfig`
- Everything else as per standard dart [guidelines]

## Testing

- Add tests for each new addition/feature
- Do not remove/change tests when refactoring
  - unless fixing already broken test.

## Features and bugs

Please file feature requests and bugs at the [issue-tracker].

## License

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Please see the [LICENSE] file in this repository for the full text

[repo]: https://github.com/devkabiir/pre_commit
[guidelines]: https://www.dartlang.org/guides/language/effective-dart/style
[commitizen]: http://commitizen.github.io/cz-cli/
[cz-emoji]: https://github.com/ngryman/cz-emoji
[signing-commits]: https://help.github.com/articles/signing-commits/
[issue-tracker]: https://www.github.com/devkabiir/pre_commit/issues
[LICENSE]: https://github.com/devkabiir/pre_commit/blob/master/LICENSE
