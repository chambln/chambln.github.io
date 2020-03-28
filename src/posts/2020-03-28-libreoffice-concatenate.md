---
author: Gregory Chamberlain
cover-image: 'media/libreoffice-concatenate.png'
date: 'Saturday, 28 March 2020'
lang: 'en-GB'
subtitle: A brief anecdote in which I use a spreadsheet application to
  manipulate lots of spreadsheets without actually opening any
  spreadsheets.
title: 'How I Merged 36 Spreadsheets In 2 Minutes---LibreOffice on the
  Command-Line'
---

A troublesome task
==================

In a recent project, I found myself tasked with the laborious feat of
painstakingly joining together tables, hundreds of thousands of rows
each, from several years of new-file-every-month spreadsheets---by hand.

At that moment, my human eyeballs were paused hovering, mouse hopelessly
scrolling past millions of cells; a bleak air beset the white walls of
my otherwise cozy student flat on that mild March morning.

I soon gathered up my pessimism until it amounted to what you might call
a stubborn sort of frustration-fueled optimism and looked for a better
way.

A simple solution
=================

Naturally, I reached for my office suite's documentation. Although
LibreOffice is primarily a graphical application, its little-known
command-line features can be life saving. A leisurely perusal of its man
page armed me with the `--convert-to` option, which does what you're
thinking.

``` {.sh}
libreoffice --convert-to csv ./*.ods    # Works with .xlsx too!
```

Some ten billion CPU cycles later---a few seconds in mammal time---I had
trivialised a daunting task that otherwise would have threatened my
lunch break. My thirty-something spreadsheets were now thirty-something
CSV files, leaving only to concatenate them.

Of course, CSV is not a spreadsheet format. Any formulas, comments,
charts and other media would be lost in this process. Fortunately for
me, these spreadsheets were just holding raw data.

Each had its first five rows reserved for useless metadata (title and
time period), and the sixth for table headings; the remainder were the
dreaded data. Using sed(1) I was able to extract only the sixth row and
concatenate the data of all CSV files onto that, writing it to
`result.csv`.

``` {.sh}
(
    sed -n 6p ./*.csv     # Print the table headings line;
    sed -s 1,6d ./*.csv   # Print each file except lines 1-6;
) > result.csv            # Write that to result.csv.
```

With just a few simple commands, I had a single well-formed CSV file
holding *all* the data, ready to be imported into LibreOffice or indeed
into R or Python or what have you.[^1] I needn't have even fumbled for
the mouse.

Potential complications
=======================

Throughout that process, I was working under the assumption that each
spreadsheet was written the same way---five rows of information I don't
care about, the same 10 or so table headings on the sixth row followed
by data and only data as far as the eye can scroll.

The presence of stray cells or breaking changes to the overall design or
nature of data gatherment in the past few years could have rendered my
monstrous CSV a totally meaningless muddle of words and numbers riddled
with silly mistakes (like many of my assignments).

In an effort to justify this assumption, I did poke around in some of
the spreadsheets at regular intervals until I was confident it was all
in the same format.

More terminal trickery
======================

There are other things LibreOffice can do programmatically. For example,
you could print a huge batch of documents to PDF

> **`--print-to-file`** \[**`--printer-name`** *printer\_name*\]
> \[**`--outdir`** *output\_dir*\] *file*...
>
> Batch print files to file. If **`--printer-name`** is not specified
> the default printer is used. If **`--outdir`** is not specified then
> the current working directory is used as the output directory for the
> converted files.
>
> Examples:
>
>     --print-to-file *.doc
>
> Prints all .doc files to the current working directory using the
> default printer.

or onto actual paper.

> **`-p`** *file*...
>
> Prints the given files to the default printer and ends. The splash
> screen does not appear.

LibreOffice also has a flexible macro system for manipulating
spreadsheets and text documents with Java, Python, JavaScript, or its
own flavour of Basic---although documentation seems limited.

While the `--convert-to` option may not be groundbreaking, and there may
well be other viable solutions, I was pleasantly surprised to find such
functionality in an office suite. I'd be interested to hear of
praiseworthy command-line support in other GUI applications!

[^1]: The `-s` switch is a GNU extension that tells sed to operate on
    each file individually, rather than as one continuous stream. Here's
    a purely POSIX equivalent:

    ``` {.sh}
    #!/bin/sh
    (
        sed -n 6p ./*.csv      # Print the table headings line;
        for i in ./*.csv; do   # For each CSV file,
            sed 1,6d "$i"      # Print its contents except lines 1-6;
        done
    ) > result.csv             # Write that to result.csv.
    ```
