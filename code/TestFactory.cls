@isTest
public class TestFactory {
   public static Account getAccount(String accountName, Boolean doInsert) {
       Account account = new Account(Name = accountName);
       if (doInsert) {
           insert account;
       }
       return account;
   }
   public static Contact getContact(Id accountId, String firstName, String lastName, Boolean doInsert){
       Contact contact = new Contact(
           FirstName = firstName,
           LastName = lastName,
           AccountId = accountId
       );
       if (doInsert) {
           insert contact;
       }
       return contact;
   }
   public static void generateAccountWithContacts(Integer numContacts) {
       Account account = getAccount('default account ltd', true);
       List<Contact> contacts = new List<Contact>();
       for (Integer i = 0; i < numContacts; i++) {
           String firstName = 'Contact';
           String lastName = 'Test' + i;
           contacts.add(getContact(account.Id, firstName, lastName, false));
       }
       insert contacts;
   }
}