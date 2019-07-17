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
from oasislmf.model_preparation.lookup import OasisBaseKeysLookup
from oasislmf.utils.data import get_ids
# Model keys server imports
from oasislmf.utils import *

class DeterministicKeysLookup(OasisBaseKeysLookup):

    @oasis_log()
    def __init__(self, keys_data_directory=None, supplier='OasisLMF', model_name='Deterministic', model_version='0.0.1'):
        """
        Initialise the static data required for the lookup.
        """
        super(self.__class__, self).__init__(
            keys_data_directory,
            supplier,
            model_name,
            model_version
        )



    @oasis_log()
    def process_locations(self, loc_df):
        """
        Process location rows - passed in as a pandas dataframe.
        """
        if 'loc_id' not in loc_df:
            loc_df['loc_id'] = get_ids(exposure_df, ['portnumber', 'accnumber', 'locnumber'])

        print(loc_df)
        for index, row in loc_df.iterrows():
            
            locuserdef1 = row['locuserdef1']
            locnumber = row['loc_id']
            print("locnumber: ",int(locnumber))
            yield {
                "loc_id": int(locnumber),
                "peril_id": 'WTC',
                "coverage_type": 1,
                "area_peril_id": 1,
                "vulnerability_id": int(locuserdef1),
                "message": '',
                "status": 'success'
            }

