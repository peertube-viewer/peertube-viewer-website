build:
    hugo
    echo -n "default-src 'self'; img-src 'self'; style-src 'self';" > public/csp.txt

lychee: build
    lychee --base-url https://peertube-viewer.sgued.fr public

