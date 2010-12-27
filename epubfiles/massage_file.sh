#!/bin/bash
for i in index*; do
	cat $i | sed 's/ lang="[^"]*"//' | \
		sed 's/href="[^"]*.html#[^"]*"//g' | \
		sed 's/href="#[^"]*"//g' | \
		sed 's/ / /g' | \
		sed 's/ / /g' | \
		sed 's/​/ /g' | \
		sed 's/“/"/g' | \
		sed 's/”/"/g' | \
		sed "s/’/'/g" > tempfile && \
	mv tempfile $i
done
