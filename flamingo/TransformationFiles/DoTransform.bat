@echo off

RaptorXML xslt --xslt-version=1 --input="Deterministic_CanLocB.xml" --output="../ValidationFiles/OED_ModelLoc.xml" --xml-validation-error-as-warning=true %* "MappingMapToDeterministic_ModelLoc.xslt"
IF ERRORLEVEL 1 EXIT/B %ERRORLEVEL%
