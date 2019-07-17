@echo off

RaptorXML xslt --xslt-version=1 --input="OED_SourceAcc.xml" --output="../ValidationFiles/OED_CanAccA.xml" --xml-validation-error-as-warning=true %* "MappingMapToOED_CanAccA.xslt"
IF ERRORLEVEL 1 EXIT/B %ERRORLEVEL%
