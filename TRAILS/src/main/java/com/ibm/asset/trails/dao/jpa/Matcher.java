package com.ibm.asset.trails.dao.jpa;

import org.hibernate.criterion.MatchMode;

public enum Matcher {
    EXACT("filter.matcher.exact", MatchMode.EXACT), ANYWHERE(
            "filter.matcher.anywhere", MatchMode.ANYWHERE), START(
            "filter.matcher.start", MatchMode.START), END("filter.matcher.end",
            MatchMode.END);

    private String messageKey;

    private MatchMode matchMode;

    Matcher(String messageKey, MatchMode matchMode) {
        this.messageKey = messageKey;
        this.matchMode = matchMode;
    }

    public String getMessageKey() {
        return messageKey;
    }

    public MatchMode getMatchMode() {
        return matchMode;
    }
}