default:
    @just --list

# Serve locally with live-reload on port 1111
serve:
    zola serve --interface 0.0.0.0 --port 1111

# Build the site into public/
build:
    zola build

# Build with drafts included
drafts:
    zola build --drafts

# Validate build (zola check verifies internal links)
check:
    zola check

# Remove build output
clean:
    rm -rf public
