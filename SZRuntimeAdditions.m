//
//  SZRuntimeAdditions.m
//  MagicHat
//
//  Created by Raphael Szwarc on Thu Mar 20 2003.
//  Copyright (c) 2003 __MyCompanyName__. All rights reserved.
//

#import "SZRuntimeAdditions.h"


#include <mach-o/ldsyms.h>
#include <mach-o/dyld.h>
#include <mach-o/loader.h>
#include <mach-o/getsect.h>
#include <mach-o/fat.h>

#import <objc/objc.h>
#import <objc/objc-runtime.h>


typedef struct mach_header*		MachHeader;
typedef struct objc_method_list*	ObjCMethodList;

#define SEC_CSTRING        "__cstring"  /* In SEG_TEXT segments */
#define SEC_MODULE_INFO    "__module_info"
#define SEC_SYMBOLS        "__symbols"
#define MaxSection 2048

static struct Section
{
    char*		filename;
    char		name[17];
    struct section*	section;
    void*		start;
    long 		vmaddr;
    long 		size;
} Sections[ MaxSection ];

static int			SectionCount = 0;
static NSMutableDictionary*	_data = nil;

@implementation SZRuntime (CategoryAdditions)

+ (void) _invalidateCatagories
{
	SectionCount = 0;
	
	[_data removeAllObjects];
}

unsigned long SZCommand (void* aStart, void* aPointer, char* aFileName)
{
	struct load_command*	aCommand = (struct load_command*) aPointer;

	if ( aCommand -> cmd == LC_SEGMENT )
	{
		struct segment_command*	aSegmentCommand = (struct segment_command *) aPointer;
		char			aName[17];
		
		strncpy ( aName, aSegmentCommand -> segname, 16 );
		aName[16] = 0;

		if ( !strcmp( aName, SEG_OBJC ) || 
			!strcmp( aName, SEG_TEXT ) || /* for MacOS X __cstring sections */
			!strcmp ( aName, "" ) /* for .o files. */)
		{
			struct section*	aSection = (struct section*) (aSegmentCommand + 1);
			int		count = aSegmentCommand -> nsects;
			int		index = 0;

			for ( index = 0; index < count; index++ )
			{
				if ( !strcmp( aSection -> segname, SEG_OBJC ) ||
					(!strcmp( aSection -> segname, SEG_TEXT ) &&
					!strcmp( aSection -> sectname, SEC_CSTRING ) ) )
				{
					Sections[ SectionCount ].filename = aFileName;
					strncpy (Sections[ SectionCount ].name, aSection -> sectname, 16);
					Sections[ SectionCount ].name[16] = 0;
					Sections[ SectionCount ].section = aSection;
					Sections[ SectionCount ].start = aStart + aSection -> offset;
					Sections[ SectionCount ].vmaddr = aSection -> addr;
					Sections[ SectionCount ].size = aSection -> size;
				
					SectionCount++;
				}
				
				aSection++;
			}
		}
	}

	return aCommand -> cmdsize;
}

void* SZTranslate (long anAddress, char* aSectionName, char* aFileName)
{
	int	count = 0;
	int	index = 0;
	
	for ( index = 0; index < SectionCount; index++ )
	{
		if ( anAddress >= Sections[ index ].vmaddr && 
			anAddress < Sections[ index ].vmaddr + Sections[ index ].size && 
			!strcmp ( Sections[ index ].name, aSectionName) )
		{
			count++;
		}
	}

	if ( count > 1 )
	{
		for ( index = 0; index < SectionCount; index++ )
		{
			if ( anAddress >= Sections[ index ].vmaddr && 
				anAddress < Sections[ index ].vmaddr + Sections[ index ].size && 
				!strcmp ( Sections[ index ].name, aSectionName ) && 
				!strcmp ( Sections[ index ].filename, aFileName ) )
			{
				return Sections[ index ].start + anAddress - Sections[ index ].vmaddr;
			}
		}
	}
	
        for ( index = 0; index < SectionCount; index++ )
        {
            if ( anAddress >= Sections[ index ].vmaddr && 
		anAddress < Sections[ index ].vmaddr + Sections[ index ].size && 
		!strcmp ( Sections[ index ].name, aSectionName) )
            {
		return Sections[ index ].start + anAddress - Sections[ index ].vmaddr;
            }
	}

	return NULL;
}

NSSet* SZSymtab(Symtab aSymtab)
{
	if ( aSymtab != NULL )
	{
		int	categoryCount = aSymtab -> cat_def_cnt;
		
		if ( categoryCount > 0 )
		{
			void**	someDefinitions = aSymtab -> defs;
			
			if ( someDefinitions != NULL )
			{
				NSMutableSet*	aSet = [NSMutableSet setWithCapacity: categoryCount];
				unsigned short	classCount = aSymtab -> cls_def_cnt;
				unsigned short	index = 0;
				
				for ( index = 0; index < categoryCount; index++ )
				{
					Category	aCategory = someDefinitions[ classCount + index ];
					
					if ( ( aCategory != NULL ) && 
						( aCategory -> category_name != NULL ) && 
						( aCategory -> class_name != NULL ) )
					{
						NSValue*	aValue = [NSValue value: &aCategory withObjCType: @encode(Category)];
					
						[aSet addObject: aValue];
					}
				}
				
				if ( [aSet count] > 0 )
				{
					return aSet;
				}
			}
		}
	}
	
	return nil;
}

NSSet* SZSection(struct Section* aSection)
{
	if ( aSection != NULL )
	{
		NSMutableSet*	aSet = [NSMutableSet set];
		Module		aModule = aSection -> start;
		int		count = aSection -> size / sizeof (struct objc_module);
		int		index = 0;
		
		//NSLog( @"SZSection %@", [NSString stringWithCString: aSection -> filename] );
		
		for ( index = 0; index < count; index++ )
		{
			NSSet*	someCategories = SZSymtab( (Symtab) SZTranslate ( aModule -> symtab, SEC_SYMBOLS, aSection -> filename ) );
			
			if ( someCategories != nil )
			{
				[aSet unionSet: someCategories];
			}
			
			aModule++;
		}
		
		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSData*) dataWithName: (NSString*) aName
{
	NSData*	someData = nil;
	
	if ( _data == nil )
	{
		_data = [[NSMutableDictionary alloc] init];
	}
	
	someData = [_data objectForKey: aName];
	
	if ( someData == nil )
	{
		someData = [NSData dataWithContentsOfMappedFile: aName];
		
		[_data setObject: someData forKey: aName];
	}
	
	return someData;
}

+ (NSSet*) categories
{
	NSMutableSet*	aSet = [NSMutableSet set];
	unsigned long	count = _dyld_image_count();
	unsigned long	index = 0;
	
	//NSLog( @"SZRuntime.categories" );
	
	for ( index = 0; index < count; index++ )
	{
		char*		aName = _dyld_get_image_name( index );
		NSString*	aFileName = [NSString stringWithCString: aName];
		NSData*		someData = [self dataWithName: aFileName];
		MachHeader	anHeader = (MachHeader) [someData bytes];
		
		if ( anHeader -> magic == MH_MAGIC )
		{
			void*	aStart = anHeader;
			void*	aPointer = anHeader;
			int	cmdCount = anHeader -> ncmds;
			int	cmdIndex = 0;
			
			aPointer += sizeof (struct mach_header);
			
			for ( cmdIndex = 0; cmdIndex < cmdCount; cmdIndex++ )
			{
				aPointer += SZCommand( aStart, aPointer, aName );
			}
		}

	}
	
	//NSLog( @"SZRuntime.categories %d", SectionCount );

	for ( index = 0; index < SectionCount; index++ )
	{
		if ( !strcmp ( Sections[ index ].name, SEC_MODULE_INFO ) )
		{
			NSSet*	someCategories = SZSection( (struct Section*) &Sections[ index ] );
			
			if ( someCategories != nil )
			{
				[aSet unionSet: someCategories];
			}
		}
	}
	
	//NSLog( @"SZRuntime.categories done" );

	if ( [aSet count] > 0 )
	{
		return aSet;
	}
	
	return nil;
}

+ (NSSet*) protocolsForCategory: (Category) aCategory
{
	if ( aCategory != NULL )
	{
		struct objc_protocol_list*	aProtocolList = aCategory -> protocols;
		NSMutableSet*			aSet = [NSMutableSet set];
		
		while ( aProtocolList != NULL )
		{
			unsigned int	count = aProtocolList -> count;
			unsigned int	index = 0;
			
			for ( index = 0; index < count; index++ )
			{
				Protocol*	aProtocol = aProtocolList -> list[index];
				
				[aSet addObject: aProtocol];
			}
			
			aProtocolList = aProtocolList  -> next;
		}

		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) _methodsWithList: (ObjCMethodList) aMethodList
{
	if ( aMethodList != NULL )
	{
		unsigned int	count = aMethodList -> method_count;
		unsigned int	index = 0;
		NSMutableSet*	aSet = [NSMutableSet setWithCapacity: count];
			
		for ( index = 0; index < count; index++ )
		{
			Method		aMethod = &aMethodList -> method_list[index];
			NSValue*	aValue = [NSValue value: &aMethod withObjCType: @encode(Method)];
				
			[aSet addObject: aValue];
		}
		
		if ( [aSet count] > 0 )
		{
			return aSet;
		}
	}
	
	return nil;
}

+ (NSSet*) classMethodsForCategory: (Category) aCategory
{
	if ( aCategory != NULL )
	{
		return [self _methodsWithList: aCategory -> class_methods];
	}
	
	return nil;
}

+ (NSSet*) instanceMethodsForCategory: (Category) aCategory
{
	if ( aCategory != NULL )
	{
		return [self _methodsWithList: aCategory -> instance_methods];
	}
	
	return nil;
}

@end
