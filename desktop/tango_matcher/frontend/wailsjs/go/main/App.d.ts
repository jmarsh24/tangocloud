// Cynhyrchwyd y ffeil hon yn awtomatig. PEIDIWCH Â MODIWL
// This file is automatically generated. DO NOT EDIT
import {main} from '../models';
import {gorm} from '../models';

export function CheckById():Promise<void>;

export function CreateDirectoryTree(arg1:string):Promise<void>;

export function GetAudioFilesInFolder(arg1:string):Promise<Array<main.AudioFile>>;

export function GetFoldersInFolder(arg1:string):Promise<Array<string>>;

export function GetMatchingRecords(arg1:string,arg2:string,arg3:string,arg4:string,arg5:string,arg6:string,arg7:string):Promise<Array<main.Mapping>>;

export function GetRecordingsWithFilter(arg1:string,arg2:string,arg3:string,arg4:string,arg5:string,arg6:string):Promise<Array<main.Recording>>;

export function ImportCsvFile():Promise<void>;

export function LatestBatchId():Promise<number>;

export function MapAllRecordings(arg1:Array<main.Mapping>):Promise<void>;

export function MapSong(arg1:gorm.DB,arg2:number,arg3:string):Promise<void>;
