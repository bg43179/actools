# actools

## Usage:
### `f`
Filter local changes associated [`rubocop`](https://docs.rubocop.org/en/stable/) warnings/errors <br/>

Enter the following into the termianl
```
f all
```

The following output appears
```
---- commited files start ------
engines/some_engine/app//some_file.rb
engines/some_engine/test/some_test.rb:27:1: C: Layout/TrailingBlankLines: 6 trailing blank lines detected.
---- commited files end ------


---- uncommited files found ------
engines/some_engine/test/some_test.rb
engines/some_engine/test/some_test.rb:72:1: C: Layout/TrailingBlankLines: 4 trailing blank lines detected.
---- uncommited files End ------
```

### `tall`

Run [`test_laucher`](https://github.com/petekinnecom/test_launcher) for all local changes <br/>

Enter the following into the termianl
```
tall
```


## Setup:
Clone the repo or download the script you need

```
git clone git@github.com:bg43179/actools.git
```

Add the path of actools to your `.bashrc`
```bash
source 'your_path/actools/tools.sh'
```

## Requirement:
  - `git`
  - [`rubocop`](https://docs.rubocop.org/en/stable/)
  - [`test_launcher`](https://github.com/petekinnecom/test_launcher)

## Trounleshooting:
  - [VSCode doesn't allow integrated terminal to run as login shell](https://github.com/microsoft/vscode/issues/7263)

    Follow the instruction or run `source ~your_path/actools/tools.sh`


## TODO:
  It's highly depended on relatvie path. Have a working branch for it.