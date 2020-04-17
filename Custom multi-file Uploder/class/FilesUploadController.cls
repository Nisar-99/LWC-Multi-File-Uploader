public class FilesUploadController {
    
    
    private static String saveTheFiles(String parentId, String fileName, String contentType, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment attach = new Attachment();
        attach.ParentId = parentId;
        attach.Name = fileName;
        attach.ContentType = contentType;
        attach.Body = EncodingUtil.base64Decode(base64Data); 
        insert attach;
        return attach.Id;
    }
    private static void appendToFile(String fileId, String base64Data) {
        base64Data = EncodingUtil.urlDecode(base64Data, 'UTF-8');
        Attachment att = [ SELECT Id, Body  FROM Attachment WHERE Id = :fileId ];
        String existingBody = EncodingUtil.base64Encode(att.Body);
        att.Body = EncodingUtil.base64Decode(existingBody + base64Data); 
        update att;
    }
    
    @AuraEnabled
    public static String saveTheChunk(String parentId, String fileId, String fileName, String contentType, String base64Data) { 
        try {
            if (String.isNotBlank(fileId)) {
                appendToFile(fileId, base64Data);
            } else {
                fileId = saveTheFiles(parentId, fileName, contentType, base64Data);
            }
            return fileId;
        } catch(Exception e) {
            System.debug('The following exception has occurred: ' + e.getMessage());
            throw new AuraHandledException(e.getMessage());
        }
    }
    
    
}