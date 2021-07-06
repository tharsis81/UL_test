CREATE DATABASE IF NOT EXISTS UserlaneAnalytics;
USE UserlaneAnalytics;

CREATE TABLE IF NOT EXISTS overview_agg_days_base 
(
    propertyId String, 
    dateID Date,
    foreignUserId String,
    action String,
    eventGroup String,
    isTargeted UInt8,
    isReached UInt8,
    isInteracted UInt8,
    rowCount UInt32
) ENGINE = MergeTree() 
PARTITION BY tuple()
ORDER BY (propertyId, dateID, action) 
SETTINGS index_granularity = 8192
;

CREATE TABLE IF NOT EXISTS overview_agg_days_states
(
    propertyId String,
    dateID Date,
    action String,
    eventGroup String,
    isTargeted UInt8,
    isReached UInt8,
    isInteracted UInt8,
    uniqUsers AggregateFunction(uniq, String),
    rowCount AggregateFunction(count, UInt64)
) ENGINE = AggregatingMergeTree() 
PARTITION BY tuple()
ORDER BY (propertyId, dateID, action) 
SETTINGS index_granularity = 8192
;
 
CREATE TABLE events_raw 
(
    jsonCategory LowCardinality(String) DEFAULT 'Unknown',
    ServerTime DateTime,
    action LowCardinality(String) DEFAULT 'Unknown',
    foreignUserId String,
    propertyId LowCardinality(String) DEFAULT '0',
    clientTime DateTime,
    uid String,
    sessionId String,
    src String,
    announcementId String,
    announcementsShown Array(String),
    announcementsTargeted Array(String),
    unreadAnnouncements Array(String),
    insertDate DateTime DEFAULT '1900-01-01 00:00:00' CODEC(Delta(4), LZ4),
    chosenLanguage String,
    unreadAnnouncementCount String,
    incompleteTutorialsCount String,
    tabsAvailable Array(String),
    tutorialsTargeted Array(String),
    tabsShown Array(String),
    chaptersShown Array(String),
    tutorialsShown Array(String),
    legacyEvent String,
    chaptersTargeted Array(String),
    tutorialId String,
    reaction String,
    promotionId String,
    announcementIdPrevious String,
    searchQuery String,
    searchVersion String,
    searchHitIndex Decimal64(4),
    searchHitScore Decimal64(4),
    searchMaxScore Decimal64(4),
    searchMaxIndex Decimal64(4),
    newSearchQuery String,
    href String,
    title String,
    tutorialPlayId String,
    srcId String,
    reason String,
    stepIndex UInt32,
    stepIndexMax UInt32,
    error String,
    tutorialEnded String,
    editorMode String,
    currentPage String,
    uuid String,
    stepId UInt64
) ENGINE = MergeTree() PARTITION BY toYYYYMM(toDate(ServerTime))
ORDER BY
  ServerTime SETTINGS index_granularity = 8192
;

CREATE TABLE IF NOT EXISTS users_firstactive 
(
  propertyId String,
  foreignUserId String,
  dateFirstActive AggregateFunction(min, Date)
) ENGINE = AggregatingMergeTree()
PARTITION BY tuple()
ORDER BY (propertyId, foreignUserId)
;
