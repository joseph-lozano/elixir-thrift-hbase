-ifndef(_hbase_types_included).
-define(_hbase_types_included, yeah).

%% struct 'TCell'

-record('TCell', {'value' :: string() | binary(),
                  'timestamp' :: integer()}).
-type 'TCell'() :: #'TCell'{}.

%% struct 'ColumnDescriptor'

-record('ColumnDescriptor', {'name' :: string() | binary(),
                             'maxVersions' = 3 :: integer(),
                             'compression' = "NONE" :: string() | binary(),
                             'inMemory' = false :: boolean(),
                             'bloomFilterType' = "NONE" :: string() | binary(),
                             'bloomFilterVectorSize' = 0 :: integer(),
                             'bloomFilterNbHashes' = 0 :: integer(),
                             'blockCacheEnabled' = false :: boolean(),
                             'timeToLive' = -1 :: integer()}).
-type 'ColumnDescriptor'() :: #'ColumnDescriptor'{}.

%% struct 'TRegionInfo'

-record('TRegionInfo', {'startKey' :: string() | binary(),
                        'endKey' :: string() | binary(),
                        'id' :: integer(),
                        'name' :: string() | binary(),
                        'version' :: integer(),
                        'serverName' :: string() | binary(),
                        'port' :: integer()}).
-type 'TRegionInfo'() :: #'TRegionInfo'{}.

%% struct 'Mutation'

-record('Mutation', {'isDelete' = false :: boolean(),
                     'column' :: string() | binary(),
                     'value' :: string() | binary(),
                     'writeToWAL' = true :: boolean()}).
-type 'Mutation'() :: #'Mutation'{}.

%% struct 'BatchMutation'

-record('BatchMutation', {'row' :: string() | binary(),
                          'mutations' :: list()}).
-type 'BatchMutation'() :: #'BatchMutation'{}.

%% struct 'TIncrement'

-record('TIncrement', {'table' :: string() | binary(),
                       'row' :: string() | binary(),
                       'column' :: string() | binary(),
                       'ammount' :: integer()}).
-type 'TIncrement'() :: #'TIncrement'{}.

%% struct 'TColumn'

-record('TColumn', {'columnName' :: string() | binary(),
                    'cell' :: 'TCell'()}).
-type 'TColumn'() :: #'TColumn'{}.

%% struct 'TRowResult'

-record('TRowResult', {'row' :: string() | binary(),
                       'columns' :: dict:dict(),
                       'sortedColumns' :: list()}).
-type 'TRowResult'() :: #'TRowResult'{}.

%% struct 'TScan'

-record('TScan', {'startRow' :: string() | binary(),
                  'stopRow' :: string() | binary(),
                  'timestamp' :: integer(),
                  'columns' :: list(),
                  'caching' :: integer(),
                  'filterString' :: string() | binary(),
                  'batchSize' :: integer(),
                  'sortColumns' :: boolean(),
                  'reversed' :: boolean()}).
-type 'TScan'() :: #'TScan'{}.

%% struct 'TAppend'

-record('TAppend', {'table' :: string() | binary(),
                    'row' :: string() | binary(),
                    'columns' :: list(),
                    'values' :: list()}).
-type 'TAppend'() :: #'TAppend'{}.

%% struct 'IOError'

-record('IOError', {'message' :: string() | binary()}).
-type 'IOError'() :: #'IOError'{}.

%% struct 'IllegalArgument'

-record('IllegalArgument', {'message' :: string() | binary()}).
-type 'IllegalArgument'() :: #'IllegalArgument'{}.

%% struct 'AlreadyExists'

-record('AlreadyExists', {'message' :: string() | binary()}).
-type 'AlreadyExists'() :: #'AlreadyExists'{}.

-endif.
