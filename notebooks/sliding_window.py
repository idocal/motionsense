import pandas as pd
import numpy as np

class SlidingWindow:

    df = None
    window_size = 0

    def create_sld_df_single_exp(self, orig_df, window_size, analytic_functions_list):
        dfs_to_concate = []
        base_df = orig_df.drop('action', axis=1)
        for func in analytic_functions_list:
            method_to_call = getattr(base_df.rolling(window=window_size), func)
            analytic_df = method_to_call()
            analytic_df = analytic_df[window_size:]
            analytic_df.columns = [col + "_sld_" + func for col in analytic_df.columns]
            dfs_to_concate.append(analytic_df)

        action_df = orig_df[['action']][window_size:] # [[]] syntax to return DataFrame and not Series
        dfs_to_concate.append(action_df)
        return pd.concat(dfs_to_concate,axis=1)

    def create_sliding_df(self, orig_df, window_size, analytic_functions_list, expirements, participants):
        dfs_to_concate = []
        cols_to_drop = ['partc', 'action_file_index']
        for e in expirements:
            for p in participants:
                exp_df = orig_df[(orig_df['partc'] == p) & (orig_df['action_file_index'] == e)]
                exp_df = exp_df.drop(cols_to_drop, axis=1)
                exp_roll_df = self.create_sld_df_single_exp(exp_df, window_size, analytic_functions_list)

                dfs_to_concate.append(exp_roll_df)
        return pd.concat(dfs_to_concate, axis=0, ignore_index=True)

    def __init__(self, orig_df, window_size, num_experiments, num_participants, exclude, fnlist):
        exps = [i for i in range(1,num_experiments + 1) if i != exclude]
        parts = [i for i in range(1,num_participants + 1)]
        smp_df = self.create_sliding_df(orig_df, window_size, fnlist, exps, parts)
        self.window_size = window_size
        self.df = smp_df
