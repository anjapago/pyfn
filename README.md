# pyfn
[![GitHub release][release-image]][release-url]
[![PyPI release][pypi-image]][pypi-url]
[![Build][travis-image]][travis-url]
[![Requirements Status][req-image]][req-url]
[![Code Coverage][coverage-image]][coverage-url]
[![FrameNet][framenet-image]][framenet-url]
[![Python][python-image]][python-url]
[![MIT License][license-image]][license-url]

Welcome to **pyfn**, a Python modules to process FrameNet XML data.

pyfn provides a set of models and utils to apply custom preprocessing
pipelines to FrameNet XML data and perform frame semantic parsing using
SEMAFOR, OPEN-SESAME or SIMPLEFRAMEID.

Currently supported formats include:
- FrameNet XML
- SEMEVAL XML
- BIOS
- CoNLL-X

Currently supported POS taggers include:
- MXPOST
- NLP4J

Currently supported dependency parsers include:
- MST
- BIST BARCH
- BIST BMST

Currently supported frame semantic parsers include:
- SIMPLEFRAMEID for frame identification
- SEMAFOR for argument identification
- OPEN-SESAME for argument identification

## Install
```
pip3 install pyfn
```

If you intend to use the SEMEVAL perl evaluation scripts, make sure
to have the `App::cpanminus` and `XML::Parser` modules installed:
```
cpan App::cpanminus
cpanm XML::Parser
```

If you intend to use the [BIST]() or [OPEN-SESAME]() parsers, you need
to install DyNET 2.0 following:
```
https://dynet.readthedocs.io/en/2.0.3/python.html
```

## Config
To use NLP4J for POS tagging, modify the `resources/config-decode-pos.xml`
file by replacing the models.pos absolute path to
your `resources/nlp4j.plemma.model.all.xz`:
```xml
<configuration>
	...
	<models>
		<pos>/absolute/path/to/pyfn/resources/nlp4j.plemma.model.all.xz</pos>
	</models>
</configuration>
```

To use the SEMAFOR frame semantic parser, modify the `scripts/setup.sh` file:
```bash
# SEMAFOR options to be changed according to your env
export JAVA_HOME_BIN="/Library/Java/JavaVirtualMachines/jdk1.8.0_20.jdk/Contents/Home/bin"
export num_threads=2 # number of threads to use
export min_ram=4g # min RAM allocated to the JVM in GB. Corresponds to the -Xms argument
export max_ram=8g # max RAM allocated to the JVM in GB. Corresponds to the -Xmx argument

# SEMAFOR hyperparameters
export kbest=1 # keep k-best parse
export lambda=0.000001 # hyperparameter for argument identification. Refer to Kshirsagar et al. (2015) for details.
export batch_size=4000 # number of batches processed at once for argument identification.
export save_every_k_batches=400 # for argument identification
export num_models_to_save=60 # for argument identification
```

## Install
To run pyfn and all the scripts located under scripts/ you need the following files:
- [data.7z](https://github.com/akb89/pyfn/releases/download/v0.1.0/data.7z) containing all the FrameNet splits for FN 1.5 and FN 1.7
- [lib.7z](https://github.com/akb89/pyfn/releases/download/v0.1.0/lib.7z) containing all the different external softwares (taggers, parsers, etc.)
- [resources.7z](https://github.com/akb89/pyfn/releases/download/v0.1.0/resources.7z) containing all the required resources

Extract the content of all the archives via `7z x archive_name.7z` under the pyfn root directory. Your pyfn folder structure should look like:
```
.
|-- pyfn
|   |-- data
|   |   |-- fndata-1.5-with-dev
|   |   |-- fndata-1.7-with-dev
|   |-- experiments
|   |-- lib
|   |   |-- bistparser
|   |   |-- jmx
|   |   |-- mstparser
|   |   |-- nlp4j
|   |   |-- open-sesame
|   |   |-- semafor
|   |   |-- semeval
|   |-- pyfn
|   |-- resources
|   |   |-- bestarchybrid.model
|   |   |-- bestarchybrid.params
|   |   |-- bestfirstorder.model
|   |   |-- bestfirstorder.params
|   |   |-- config-decode-pos.xml
|   |   |-- nlp4j.plemma.model.all.xz
|   |   |-- sskip.100.vectors
|   |   |-- wsj.model
|   |-- scripts
|   |-- tests
```

Modify the `resources/config-decode-pos.xml` file by replace the
models.pos absolute path to your `resources/nlp4j.plemma.model.all.xz`
```xml
<configuration>
	...
	<models>
		<pos>/absolute/path/to/pyfn/resources/nlp4j.plemma.model.all.xz</pos>
	</models>
</configuration>
```

To use the scripts, modify the `scripts/setup.sh` file:
```bash
export JAVA_HOME_BIN="/path/to/java/bin"
export num_threads=2
export min_ram=4g # min RAM allocated to the JVM in GB. Corresponds to the -Xms argument
export max_ram=8g # max RAM allocated to the JVM in GB. Corresponds to the -Xmx argument
...
export OPEN_SESAME_HOME="/absolute/path/to/open-sesame"
...
```

On linux, install the following dependencies:
```bash
sudo apt-get install libxml2 libxml2-dev libxslt1-dev
```
Also PERL modules:
```
sudo cpan App::cpanminus
sudo cpanm XML::Parser
```
To install the **pyfn** app, run the following command under the pyfn/ root directory:
```bash
sudo -H python3 setup.py develop
```
DyNET also required for BIST and OPEN-SESAME
## Corentin
You want to replicate XP#045. Don't forget to change the batch_size to 40,000 instead of 4,000 in the `setup.sh` file.
Also, you may need to manually copy `data/fndata-1.5-with-dev/framenet.frame.element.map` to the `experiments/xp_045/data` directory

## TODO
- [x] FN to BIOS
- [x] FN to SEMEVAL
- [x] FN to SEMAFOR
- [x] BIOS to SEMEVAL
- [x] SEMAFOR to SEMEVAL
- [x] pos tagging MXPOST
- [x] pos tagging NLP4J
- [x] dep parsing MST
- [x] dep parsing with BMST or BARCH
- [x] lemmatize MXPOST
- [x] flatten all.lemma.tags
- [x] merge .bios and .conllx
- [x] open-sesame frame data
- [ ] frame identification
- [ ] hierarchy feature on FN 1.7
- [ ] vocab vector on FN 1.7

## Dependencies
On Linux:
```
sudo apt-get install libxml2 libxml2-dev libxslt1-dev
```

## Duplicates in test set
In the test set there can be duplicate annotationsets. Ex:
```xml
<sentence ID="246">
  <text>The pilot perished in the crash .</text>
  <annotationSets>
    <annotationSet ID="786" frameName="Death">
      <layers>
        <layer ID="1553" name="Target">
          <labels>
            <label ID="2343" name="Target" start="10" end="17"/>
          </labels>
        </layer>
        <layer ID="1554" name="FE">
          <labels>
            <label ID="2344" name="Protagonist" start="0" end="8"/>
            <label ID="2345" name="Sub_event" start="19" end="30"/>
            <label ID="2346" name="Cause" start="19" end="30"/>
          </labels>
        </layer>
      </layers>
    </annotationSet>
  </annotationSets>
</sentence>
```

## Refactoring and test set
With our refactoring on the test set, we went from 4428 annotationsets
to 4457 annotationsets


Special limit case to test for BIOS marshalling:
with wrong tokenization of `doin'tonight` labels are on `doin` which needs to
be taken into account in the `_get_fe_label` function
```xml
<sentence corpID="204" docID="709" sentNo="3" paragNo="29" aPos="0" ID="1277105">
        <text>There 's some stuff that we could doin'tonight .</text>
<annotationSet cDate="09/17/2007 02:39:01 PDT Mon" luID="10156" luName="can.v" frameID="990" frameName="Capability" status="MANUAL" ID="2016063">
            <layer rank="1" name="Target">
                <label cBy="361" end="32" start="28" name="Target"/>
            </layer>
            <layer rank="1" name="FE">
                <label cBy="361" feID="5982" bgColor="008000" fgColor="FFFFFF" end="37" start="34" name="Event"/>
                <label cBy="361" feID="5982" bgColor="008000" fgColor="FFFFFF" end="18" start="9" name="Event"/>
                <label cBy="361" feID="5982" bgColor="008000" fgColor="FFFFFF" end="23" start="20" name="Event"/>
                <label cBy="361" feID="5981" bgColor="FF0000" fgColor="FFFFFF" end="26" start="25" name="Entity"/>
            </layer>
            <layer rank="1" name="GF">
                <label end="37" start="34" name="Dep"/>
                <label end="18" start="9" name="Dep"/>
                <label end="23" start="20" name="Dep"/>
                <label end="26" start="25" name="Ext"/>
            </layer>
            <layer rank="1" name="PT">
                <label end="37" start="34" name="VPbrst"/>
                <label end="18" start="9" name="VPbrst"/>
                <label end="23" start="20" name="VPbrst"/>
                <label end="26" start="25" name="NP"/>
            </layer>
            <layer rank="1" name="Other">
                <label end="18" start="9" name="Ant"/>
                <label end="23" start="20" name="Rel"/>
            </layer>
            <layer rank="1" name="Sent"/>
            <layer rank="1" name="Verb"/>
        </annotationSet>
```

## HowTo
For all usages of pyfn, your FrameNet splits directory should follow:
```
.
|-- fndata-1.x
|   |-- train
|   |   |-- fulltext
|   |   |-- lu
|   |-- dev
|   |   |-- fulltext
|   |   |-- lu
|   |-- test
|   |   |-- fulltext
|   |   |-- lu
```

### From FN XML to BIOS
```bash
pyfn --from fnxml --to bios --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir
```
To add exemplars to fulltext data, do:
```bash
pyfn --from fnxml --to bios --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir --with_exemplars true
```

### From FN XML to CoNLL
```bash
pyfn --from fnxml --to conll --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir
```
To add exemplars to fulltext data, do:
```bash
pyfn --from fnxml --to conll --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir --with_exemplars true
```

### From FN XML to SEMEVAL XML
To generate a `dev.gold.xml` file in SEMEVAL format:
```bash
pyfn --from fnxml --to semeval --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir --splits dev
```
To generate a `test.gold.xml` file in SEMEVAL format:
```bash
pyfn --from fnxml --to semeval --source /abs/path/to/fn/splits/dir --target /abs/path/to/output/dir --splits test
```

### From BIOS to SEMEVAL XML
```bash
pyfn --from bios --to semeval --source /abs/path/to/bios/file --target /abs/path/to/output/dir
```

### From CoNLL to SEMEVAL XML
```bash
pyfn --from conll --to semeval --source /abs/path/to/conll/file --target /abs/path/to/output/dir
```


## Notes on splits
We implemented additional filtering to make sure train and test data did not
overlap.
Example with the sentence:
```
Even if Iran possesses these biological agents , it faces a significant challenge in their weaponization and delivery .
```
Present in the test set in `KBEval__utd-icsi.xml` and in the train set in `NTI__Iran_Biological.xml`
Problem is present in open-sesame fulltext mode:
in train:
```
1	Even	_	Even	rb	RB	1551	_	_	_	_	_	_	_	O
2	if	_	if	in	IN	1551	_	_	_	_	_	_	_	O
3	Iran	_	Iran	NP	NNP	1551	_	_	_	_	_	_	_	S-Owner
4	possesses	_	posse	VVZ	NNS	1551	_	_	_	_	_	possess.v	Possession	O
5	these	_	these	dt	DT	1551	_	_	_	_	_	_	_	B-Possession
6	biological	_	biological	jj	JJ	1551	_	_	_	_	_	_	_	I-Possession
7	agents	_	agent	nns	NNS	1551	_	_	_	_	_	_	_	I-Possession
8	,	_	,	,	,	1551	_	_	_	_	_	_	_	O
9	it	_	it	PP	PRP	1551	_	_	_	_	_	_	_	O
10	faces	_	face	VVZ	VBZ	1551	_	_	_	_	_	_	_	O
11	a	_	a	dt	DT	1551	_	_	_	_	_	_	_	O
12	significant	_	significant	jj	JJ	1551	_	_	_	_	_	_	_	O
13	challenge	_	challenge	nn	NN	1551	_	_	_	_	_	_	_	O
14	in	_	in	in	IN	1551	_	_	_	_	_	_	_	O
15	their	_	their	PP$	PRP$	1551	_	_	_	_	_	_	_	O
16	weaponization	_	weaponization	nn	NN	1551	_	_	_	_	_	_	_	O
17	and	_	and	cc	CC	1551	_	_	_	_	_	_	_	O
18	delivery	_	delivery	nn	NN	1551	_	_	_	_	_	_	_	O
19	.	_	.	sent	.	1551	_	_	_	_	_	_	_	O
```

in test:
```
1	Even	_	Even	rb	RB	1418	_	_	_	_	_	_	_	O
2	if	_	if	in	IN	1418	_	_	_	_	_	_	_	O
3	Iran	_	Iran	NP	NNP	1418	_	_	_	_	_	_	_	O
4	possesses	_	posse	VVZ	NNS	1418	_	_	_	_	_	_	_	O
5	these	_	these	dt	DT	1418	_	_	_	_	_	_	_	O
6	biological	_	biological	jj	JJ	1418	_	_	_	_	_	_	_	O
7	agents	_	agent	nns	NNS	1418	_	_	_	_	_	_	_	O
8	,	_	,	,	,	1418	_	_	_	_	_	_	_	O
9	it	_	it	PP	PRP	1418	_	_	_	_	_	_	_	O
10	faces	_	face	VVZ	VBZ	1418	_	_	_	_	_	_	_	O
11	a	_	a	dt	DT	1418	_	_	_	_	_	_	_	O
12	significant	_	significant	jj	JJ	1418	_	_	_	_	_	_	_	O
13	challenge	_	challenge	nn	NN	1418	_	_	_	_	_	_	_	O
14	in	_	in	in	IN	1418	_	_	_	_	_	_	_	O
15	their	_	their	PP$	PRP$	1418	_	_	_	_	_	_	_	S-Material
16	weaponization	_	weaponization	nn	NN	1418	_	_	_	_	_	weaponization.n	Processing_materials	O
17	and	_	and	cc	CC	1418	_	_	_	_	_	_	_	O
18	delivery	_	delivery	nn	NN	1418	_	_	_	_	_	_	_	O
19	.	_	.	sent	.	1418	_	_	_	_	_	_	_	O

```

ERRORS in open-sesame:
Making multi-token jump like the `having` in:
`...Iran admitted to HAVING imported...`:
```
1	Additionally	_	Additionally	rb	RB	2047	_	_	_	_	_	_	_	O
2	,	_	,	,	,	2047	_	_	_	_	_	_	_	O
3	Iran	_	Iran	NP	NNP	2047	_	_	_	_	_	_	_	O
4	admitted	_	admit	VVD	VBD	2047	_	_	_	_	_	_	_	O
5	to	_	to	to	TO	2047	_	_	_	_	_	_	_	O
6	imported	_	import	VVN	VBN	2047	_	_	_	_	_	_	_	O
7	from	_	from	in	IN	2047	_	_	_	_	_	_	_	O
8	China	_	China	NP	NNP	2047	_	_	_	_	_	_	_	O
9	1.8	_	1.8	cd	CD	2047	_	_	_	_	_	_	_	S-Count
10	tons	_	ton	nns	NNS	2047	_	_	_	_	_	ton.n	Measure_mass	S-Unit
11	of	_	of	in	IN	2047	_	_	_	_	_	_	_	B-Stuff
12	nuclear	_	nuclear	jj	JJ	2047	_	_	_	_	_	_	_	I-Stuff
13	material	_	material	nn	NN	2047	_	_	_	_	_	_	_	I-Stuff
14	(	_	(	(	:	2047	_	_	_	_	_	_	_	I-Stuff
15	UF6	_	UF6	NP	NNP	2047	_	_	_	_	_	_	_	I-Stuff
16	,	_	,	,	,	2047	_	_	_	_	_	_	_	I-Stuff
17	UF4	_	UF4	NP	NNP	2047	_	_	_	_	_	_	_	I-Stuff
18	and	_	and	cc	CC	2047	_	_	_	_	_	_	_	I-Stuff
19	UO2	_	UO2	jj	NNP	2047	_	_	_	_	_	_	_	I-Stuff
20	)	_	)	)	NNP	2047	_	_	_	_	_	_	_	I-Stuff
21	used	_	use	VVN	VBD	2047	_	_	_	_	_	_	_	O
22	to	_	to	to	TO	2047	_	_	_	_	_	_	_	O
23	manufacture	_	manufacture	VV	VB	2047	_	_	_	_	_	_	_	O
24	uranium	_	uranium	nn	NN	2047	_	_	_	_	_	_	_	O
25	metal	_	metal	nn	NN	2047	_	_	_	_	_	_	_	O
26	,	_	,	,	,	2047	_	_	_	_	_	_	_	O
27	which	_	which	wdt	WDT	2047	_	_	_	_	_	_	_	O
28	is	_	be	VBZ	VBZ	2047	_	_	_	_	_	_	_	O
29	essential	_	essential	jj	JJ	2047	_	_	_	_	_	_	_	O
30	in	_	in	in	IN	2047	_	_	_	_	_	_	_	O
31	weapons	_	weapon	nns	NNS	2047	_	_	_	_	_	_	_	O
32	production	_	production	nn	NN	2047	_	_	_	_	_	_	_	O
33	.	_	.	sent	.	2047	_	_	_	_	_	_	_	O
```

## Notes on preprocessing
We filtered out (in train splits) annotationsets which contained overlapping
labels as this is incompatible with BIOS tagging. Ex:
```xml
<annotationSet cDate="10/26/2007 01:19:33 PDT Fri" luID="14604" luName="clear.v" frameID="506" frameName="Grant_permission" status="MANUAL" ID="2017100">
    <layer rank="1" name="Target">
        <label cBy="361" end="10" start="5" name="Target"/>
    </layer>
    <layer rank="1" name="FE">
        <label cBy="361" feID="4076" bgColor="FF0000" fgColor="FFFFFF" end="3" start="0" name="Grantor"/>
        <label cBy="361" feID="4078" bgColor="2E8B57" fgColor="FFFFFF" end="53" start="12" name="Action"/>
    </layer>
    <layer rank="1" name="GF">
        <label end="3" start="0" name="Ext"/>
        <label end="53" start="12" name="Obj"/>
    </layer>
    <layer rank="1" name="PT">
        <label end="3" start="0" name="NP"/>
        <label end="53" start="12" name="NP"/>
    </layer>
    <layer rank="1" name="Other"/>
    <layer rank="1" name="Sent"/>
    <layer rank="1" name="Verb"/>
    <layer rank="2" name="FE">
        <label cBy="361" feID="4077" bgColor="0000FF" fgColor="FFFFFF" end="53" start="21" name="Grantee"/>
    </layer>
</annotationSet>
```

```
1	Iraq	_	Iraq	NP	NNP	1519	_	_	_	_	_	_	_	S-Grantor
2	clears	_	clear	VVZ	NNS	1519	_	_	_	_	_	clear.v	Grant_permission	O
3	visit	_	visit	nn	NN	1519	_	_	_	_	_	_	_	B-Action
4	by	_	by	in	IN	1519	_	_	_	_	_	_	_	I-Action
5	Ohio	_	Ohio	NP	NNP	1519	_	_	_	_	_	_	_	I-Action
6	official	_	official	nn	NN	1519	_	_	_	_	_	_	_	I-Action
7	By	_	By	in	IN	1519	_	_	_	_	_	_	_	I-Action
8	Scott	_	Scott	NP	NNP	1519	_	_	_	_	_	_	_	I-Action
9	Montgomery	_	Montgomery	NP	NNP	1519	_	_	_	_	_	_	_	I-Action
```

## PyPI

https://tom-christie.github.io/articles/pypi/

```python
import pypandoc

#converts markdown to reStructured
z = pypandoc.convert('README','rst',format='markdown')

#writes converted file
with open('README.rst','w') as outfile:
    outfile.write(z)
```

[release-image]:https://img.shields.io/github/release/akb89/pyfn.svg?style=flat-square
[release-url]:https://github.com/akb89/pyfn/releases/latest
[pypi-image]:https://img.shields.io/pypi/v/pyfn.svg?style=flat-square
[pypi-url]:https://github.com/akb89/pyfn/releases/latest
[travis-image]:https://img.shields.io/travis/akb89/pyfn.svg?style=flat-square
[travis-url]:https://travis-ci.org/akb89/pyfn
[coverage-image]:https://img.shields.io/coveralls/akb89/pyfn/master.svg?style=flat-square
[coverage-url]:https://coveralls.io/github/akb89/pyfn?branch=master
[framenet-image]:https://img.shields.io/badge/framenet-1.5%E2%87%A1-blue.svg?style=flat-square
[framenet-url]:https://framenet.icsi.berkeley.edu/fndrupal
[python-image]:https://img.shields.io/pypi/pyversions/pyfn.svg?style=flat-square
[python-url]:https://github.com/akb89/pyfn/releases/latest
[license-image]:http://img.shields.io/badge/license-MIT-000000.svg?style=flat-square
[license-url]:LICENSE.txt
[req-url]:https://requires.io/github/akb89/pyfn/requirements/?branch=master
[req-image]:https://img.shields.io/requires/github/akb89/pyfn.svg?style=flat-square
