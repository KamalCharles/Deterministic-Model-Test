# -*- coding: utf-8 -*-

__all__ = [
  'DeterministicKeysLookup'
] 

# Python standard library imports
#import io
import json
#import logging
#import math
#import os

# Python non-standard library imports
import pandas as pd

# Oasis utils and other Oasis imports
#import importlib; import oasislmf
#from oasislmf.utils.data import get_dataframe 
from oasislmf.utils.log import oasis_log
#from oasislmf.utils.metadata import OASIS_KEYS_STATUS
from oasislmf.model_preparation.lookup import OasisBaseKeysLookup
#from oasislmf.utils.data import get_ids
# Model keys server imports
#from oasislmf.utils import *

class DeterministicKeysLookup(OasisBaseKeysLookup):

    @oasis_log()
    def __init__(self, 
            keys_data_directory=None, 
            supplier='OasisLMF', 
            model_name='Deterministic', 
            model_version='0.0.1',
            complex_lookup_config_fp=None,
            output_directory=None
        ):
        """
        Initialise the static data required for the lookup.
        """
        super(self.__class__, self).__init__(
            keys_data_directory,
            supplier,
            model_name,
            model_version,
            complex_lookup_config_fp,
            output_directory
        )



    @oasis_log()
    def process_locations(self, loc_df):
        """
        Process location rows - passed in as a pandas dataframe.
        """
        required_columns = {
            1:"flexilocbuildingdr",
            2:"flexilocotherdr",
            3:"flexiloccontentsdr",
            4:"flexilocbidr"
            }

        #set dr = 100 where not provided
        loc_df_cols = loc_df.columns
        for col_id in required_columns:
            if required_columns[col_id] not in loc_df_cols:
                loc_df[required_columns[col_id]] = 100


        for index, row in loc_df.iterrows():
            for cov in range(1,5):
                dr_col = required_columns[cov]
                dr = row[[dr_col]]
                locnumber = row['loc_id']
                yield {
                    "loc_id": int(locnumber),
                    "peril_id": 'WTC',
                    "coverage_type": int(cov),
                    "area_peril_id": 1,
                    "vulnerability_id": int(dr),
                    "message": '',
                    "status": 'success'
                }

