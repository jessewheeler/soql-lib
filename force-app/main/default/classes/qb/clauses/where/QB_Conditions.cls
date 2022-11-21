public class QB_Conditions extends QB_QueryClause {

    private List<QB_Condition> queryConditions = new List<QB_Condition>();
    private String conditionOrder = '';

    public QB_Conditions(QB_Condition queryCondition) {
        this.addCondition(queryCondition);
    }

    public QB_Conditions(List<QB_Condition> queryConditions) {
        this.addConditions(queryConditions);
    }

    public QB_Conditions addCondition(QB_Condition queryCondition) {
        this.queryConditions.add(queryCondition);
        return this;
    }

    public QB_Conditions addConditions(List<QB_Condition> queryConditions) {
        this.queryConditions.addAll(queryConditions);
        return this;
    }

    public QB_Conditions setConditionsOrder(String conditionsOrder) {
        this.conditionOrder = conditionsOrder;
        return this;
    }

    public override String build() {
        if (this.queryConditions.isEmpty()) {
            return '';
        }

        if (String.isEmpty(this.conditionOrder)) {
            this.conditionOrder = QB_ConditionsUtils.buildDefaultConditionsOrder(this.queryConditions);
        }

        return QB_ConditionsUtils.getConditionsWithFilteringExpressions(this.queryConditions, this.conditionOrder);
    }

    public Boolean hasConditions() {
        return !this.queryConditions.isEmpty();
    }
}