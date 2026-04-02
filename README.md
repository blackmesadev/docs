# Black Mesa docs

this repo contains the Black Mesa documentation site built with Zola

## Install Zola

Install Zola using one of the following methods:

```bash
# cargo
cargo install zola
```

```bash
# Arch Linux
sudo pacman -S zola
```

```bash
# macOS with Homebrew
brew install zola
```

## run locally

with `just`:

```bash
just serve
```

The local site will be available at `http://127.0.0.1:1111`.

## building
To generate the static site into `public/`:

```bash
just build
```

