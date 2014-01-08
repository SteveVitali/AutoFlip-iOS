//  OpenEars 
//  http://www.politepix.com/openears
//
//  LanguageModelGenerator.h
//  OpenEars
//
//  LanguageModelGenerator is a class which creates new grammars
//
//  Copyright Politepix UG (haftungsbeschränkt) 2012. All rights reserved.
//  http://www.politepix.com
//  Contact at http://www.politepix.com/contact
//
//  This file is licensed under the Politepix Shared Source license found in the root of the source distribution.


/**
 @class  LanguageModelGenerator
 @brief  The class that generates the vocabulary the PocketsphinxController is able to understand.
 
 ## Usage examples
 > What to add to your implementation:
 @htmlinclude LanguageModelGenerator_Implementation.txt
 > How to use the class methods:
 @htmlinclude LanguageModelGenerator_Calls.txt 
 */

@class GraphemeGenerator;
@interface LanguageModelGenerator : NSObject {
    
    /**Set this to TRUE to get verbose output*/
    BOOL verboseLanguageModelGenerator;



    /**Advanced: if you are using your own acoustic model or an custom dictionary contained within an acoustic model and these don't use the same phonemes as the English or Spanish acoustic models, you will need to set useFallbackMethod to FALSE so that no attempt is made to use the English or Spanish fallback method for finding pronunciations of words which don't appear in the custom acoustic model's phonetic dictionary.*/    
    BOOL useFallbackMethod;
        
    /**\cond HIDDEN_SYMBOLS*/ 
    NSMutableCharacterSet *sanitizeDictionaryCharacterSet;
  
    NSString *pathToCachesDirectory;
    GraphemeGenerator *graphemeGenerator;
    BOOL outputDMP;    
    /**\endcond*/ 
  
}
@property(nonatomic,assign)    BOOL verboseLanguageModelGenerator;
@property(nonatomic,assign) BOOL useFallbackMethod;


/**\cond HIDDEN_SYMBOLS*/ 

@property(nonatomic,retain) NSMutableCharacterSet *sanitizeDictionaryCharacterSet;
@property(nonatomic,copy) NSString * pathToCachesDirectory;
@property(nonatomic,retain) GraphemeGenerator *graphemeGenerator;
@property(nonatomic,assign) BOOL outputDMP;
/**\endcond*/ 


/**Generate a language model from an array of NSStrings which are the words and phrases you want PocketsphinxController or PocketsphinxController+RapidEars to understand, using your chosen acoustic model. Putting a phrase in as a string makes it somewhat more probable that the phrase will be recognized as a phrase when spoken. fileName is the way you want the output files to be named, for instance if you enter "MyDynamicLanguageModel" you will receive files output to your Caches directory titled MyDynamicLanguageModel.dic, MyDynamicLanguageModel.arpa, and MyDynamicLanguageModel.DMP. The error that this method returns contains the paths to the files that were created in a successful generation effort in its userInfo when NSError == noErr. The words and phrases in languageModelArray must be written with capital letters exclusively, for instance "word" must appear in the array as "WORD". */

- (NSError *) generateLanguageModelFromArray:(NSArray *)languageModelArray withFilesNamed:(NSString *)fileName forAcousticModelAtPath:(NSString *)acousticModelPath;



/**Generate a language model from a text file containing words and phrases you want PocketsphinxController to understand, using your chosen acoustic model. The file should be formatted with every word or contiguous phrase on its own line with a line break afterwards. Putting a phrase in on its own line makes it somewhat more probable that the phrase will be recognized as a phrase when spoken. Give the correct full path to the text file as a string. fileName is the way you want the output files to be named, for instance if you enter "MyDynamicLanguageModel" you will receive files output to your Caches directory titled MyDynamicLanguageModel.dic, MyDynamicLanguageModel.arpa, and MyDynamicLanguageModel.DMP. The error that this method returns contains the paths to the files that were created in a successful generation effort in its userInfo when NSError == noErr. The words and phrases in languageModelArray must be written with capital letters exclusively, for instance "word" must appear in the array as "WORD". */

- (NSError *) generateLanguageModelFromTextFile:(NSString *)pathToTextFile withFilesNamed:(NSString *)fileName forAcousticModelAtPath:(NSString *)acousticModelPath;




@end
