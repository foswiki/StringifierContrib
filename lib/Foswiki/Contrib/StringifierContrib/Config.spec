# ---+ Extensions
# ---++ StringifierContrib

# **BOOLEAN EXPERT**
# Debug setting
$Foswiki::cfg{StringifierContrib}{Debug} = 0;

# ---+++ Indexer 
# **SELECT w3m, lynx, links, html2text **
# Select which HTML indexer to use (you need to install the respective tool of course)
$Foswiki::cfg{StringifierContrib}{HtmlIndexer} = 'w3m';

# **SELECT abiword, antiword, catdoc, soffice, wv,none **
# Select which MS Word indexer to use (you need to have antiword, abiword or wvText installed).
# <dl>
# <dt>abiword</dt><dd></dd>
# <dt>antiword</dt><dd>chould be used on Linux/Unix but may have problems with doc files generated by OpenOffice</dd>
# <dt>catdoc</dt><dd></dd>
# <dt>soffice</dt><dd>is the most capable of all converters but may be slow</dd>
# <dt>wvText</dt><dd>is the default</dd>
# <dt>none</dt><dd>don't index word documents</dd>
# </dl>
$Foswiki::cfg{StringifierContrib}{WordIndexer} = 'antiword';

# **SELECT catppt,script,soffice,none**
# Select which indexer to use to extract the text of a Powerpoint file (ppt, pptx).
# <dl>
# <dt>catppt</dt><dd>is the default</dd>
# <dt>script</dt><dd>uses ppthtml </dd>
# <dt>soffice</dt><dd>is the most capable of all converters but may be slow</dd>
# <dt>none</dt><dd>don't index powerpoint documents</dd>
# </dl>
$Foswiki::cfg{StringifierContrib}{PowerpointIndexer} = 'script';

# **SELECT script,soffice,none**
# Select which indexer to use to extract the text of an XLS file.
# <dl>
# <dt>script</dt><dd>default </dd>
# <dt>soffice</dt><dd>is the most capable of all converters but may be slow</dd>
# <dt>none</dt><dd>don't index excel documents</dd>
# </dl>
$Foswiki::cfg{StringifierContrib}{ExcelIndexer} = 'script';

# **SELECT script,xlsx2csv,soffice,none**
# Select which indexer to use to extract the text of an XLS file.
# <dl>
# <dt>script</dt><dd>default</dd>
# <dt>xlsx2csv</dt><dd></dd>
# <dt>soffice</dt><dd></dd>
# <dt>none</dt><dd>don't index excel documents</dd>
# </dl>
$Foswiki::cfg{StringifierContrib}{Excel2Indexer} = 'script';

# ---+++ Commands
# **COMMAND CHECK='undefok' **
# Path to your abiword command (used to convert MS word documents: .doc)
$Foswiki::cfg{StringifierContrib}{abiwordCmd} = 'abiword';

# **COMMAND CHECK='undefok'**
# Path to your soffice command (used to convert MS word documents: .doc and .docx)
$Foswiki::cfg{StringifierContrib}{sofficeCmd} = 'soffice';

# **COMMAND CHECK='undefok'**
# Path to your antiword command (used to convert MS word documents: .doc).
# On a hosted server, you might need to tell antiword where to look for
# its mapping files using some environment directives:
# <code>/usr/bin/env ANTIWORDHOME=/home2/mydomain/.antiword /home2/mydomain/bin/antiword</code>
$Foswiki::cfg{StringifierContrib}{antiwordCmd} = 'antiword';

# **COMMAND CHECK='undefok'**
# Path to your wvText command (used to convert MS word documents: .doc)
$Foswiki::cfg{StringifierContrib}{wvTextCmd} = 'wvText';

# **COMMAND CHECK='undefok'**
# Path to your ppthtml command (used to convert MS powerpoint documents: .ppt)
$Foswiki::cfg{StringifierContrib}{ppthtmlCmd} = 'ppthtml';

# **COMMAND CHECK='undefok'**
# Path to your catppt command (used to convert MS powerpoint documents: .ppt)
$Foswiki::cfg{StringifierContrib}{catpptCmd} = 'catppt';

# **COMMAND CHECK='undefok'**
# Path to your catdoc command (used to convert MS word documents: .doc)
$Foswiki::cfg{StringifierContrib}{catdocCmd} = 'catdoc';

# **COMMAND CHECK='undefok'**
# Path to your odt2txt command (used to convert OpenDocument and Staroffice documents: .odt, .odp, sxw, sxc, ...)
$Foswiki::cfg{StringifierContrib}{odt2txt} = 'odt2txt';

# **COMMAND CHECK='undefok'**
# Path to html2text command
$Foswiki::cfg{StringifierContrib}{html2textCmd} = 'html2text';

# **COMMAND CHECK='undefok'**
# Path to w3m command
$Foswiki::cfg{StringifierContrib}{w3mCmd} = 'w3m';

# **COMMAND CHECK='undefok'**
# Path to lynx command
$Foswiki::cfg{StringifierContrib}{lynxCmd} = 'lynx';

# **COMMAND CHECK='undefok'**
# Path to links command
$Foswiki::cfg{StringifierContrib}{linksCmd} = 'links';

# **COMMAND CHECK='undefok'**
# Path to your pdftotext command (used to convert PDF files)
$Foswiki::cfg{StringifierContrib}{pdftotextCmd} = 'pdftotext';

# **COMMAND CHECK='undefok'**
# Path to your pptx2txt.pl command (used to convert MS powerpoint recent documents: .pptx)
$Foswiki::cfg{StringifierContrib}{pptx2txtCmd} = '../tools/pptx2txt.pl';

# **COMMAND CHECK='undefok'**
# Path to your docx2txt.pl command (used to convert MS word recent documents: .docx)
$Foswiki::cfg{StringifierContrib}{docx2txtCmd} = '../tools/docx2txt.pl';

# **COMMAND CHECK='undefok'**
# Path to your xls2txt.pl command (used to convert MS excel recent documents: .xls)
$Foswiki::cfg{StringifierContrib}{xls2txtCmd} = '../tools/xls2txt.pl';

# **COMMAND CHECK='undefok'**
# Path to your xlsx2txt.pl command (used to convert newer MS Excel documents .xlsx)
$Foswiki::cfg{StringifierContrib}{xlsx2txtCmd} = '../tools/xlsx2txt.pl';

# **COMMAND CHECK='undefok'**
# Path to your xlsx2csv command (used to convert MS word documents: .doc)
$Foswiki::cfg{StringifierContrib}{xlsx2csv} = 'xlsx2csv';

# ---+++ Charsets
# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the soffice helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{soffice} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the abiword helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{abiword} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the antiword helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{antiword} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the docx2txt helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{docx2txt} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the html2text helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{html2text} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the odt2txt helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{odt2txt} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the pdftotext helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{pdftotext} = 'iso-8859-1';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the pptx2txt helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{pptx2txt} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the text extractor. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{text} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the wv helper program. 
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{wv} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by the xls2txt helper programm.
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{xls2txt} = 'utf-8';

# **STRING CHECK='undefok' EXPERT**
# Set this to the charset encoding produced by thew xlsx text extractor.
# This is most probably either 'utf-8' or 'iso-8859-1'.
# Values differ depending on the version and system configuration.
$Foswiki::cfg{StringifierContrib}{CharSet}{xlsx} = 'utf-8';

1;
