# -*- coding: utf-8 -*-

__all__ = [
  'DeterministicKeysLookup'
] 

# Python standard library imports
import io
import json
import logging
import math
import os

# Python non-standard library imports
import pandas as pd

# Oasis utils and other Oasis imports
import importlib; import oasislmf
from oasislmf.utils.data import get_dataframe 
from oasislmf.utils.log import oasis_log
#from oasislmf.utils.metadata import OASIS_KEYS_STATUS
from oasislmf.model_preparation.lookup import OasisLookupFactory as olf, OasisLookup, OasisPerilLookup, OasisVulnerabilityLookup

# Model keys server imports
from oasislmf.utils import *

class DeterministicKeysLookup(olf):

    @oasis_log()
    def process_locations(self, loc_df):
        """
        Process location rows - passed in as a pandas dataframe.
        """
        for index, row in loc_df.iterrows():
            
            locuserdef1 = row['locuserdef1']
            
            yield {
                "id": int(row['locnumber']),
                "peril_id": 'WTC',
                "coverage_type": 1,
                "area_peril_id": 1,
                "vulnerability_id": int(locuserdef1),
                "message": '',
                "status": 'success'
            }
