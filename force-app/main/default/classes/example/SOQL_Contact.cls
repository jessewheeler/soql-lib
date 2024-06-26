public inherited sharing class SOQL_Contact extends SOQL implements SOQL.Selector {
    public static final String MOCK_ID = 'SOQL_Contact';

    public static SOQL_Contact query() {
        return new SOQL_Contact();
    }

    private SOQL_Contact() {
        super(Contact.SObjectType);
        // default settings
        with(Contact.Id, Contact.Name, Contact.AccountId);
        systemMode();
        withoutSharing();
        mockId(MOCK_ID);
    }

    public SOQL_Contact byAccountId(Id accountId) {
        whereAre(Filter.with(Contact.AccountId).equal(accountId));
        return this;
    }

    public String toName(Id contactId) {
        return (String) query().byId(contactId).toValueOf(Contact.Name);
    }
}
