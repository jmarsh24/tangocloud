import {useEffect, useState} from 'react';
import './App.css';
import {EventsOn, LogPrint} from "../wailsjs/runtime/runtime"
import {ImportCsvFile, GetFoldersInFolder, GetAudioFilesInFolder, GetRecordingsWithFilter, PrintLog, MapSong, GetMatchingRecords, MapAllRecordings} from "../wailsjs/go/main/App";
import { debounce } from "lodash"
import React from 'react';

interface Mapping {
	MatchingWordOne : string;
	MatchingWordTwo : string;
	MusicId         : number;
    RecordingTitle  : string;
	FilePath        : string;
    FileName        : string;
    Finished        : boolean;
}

interface Recording {
    Date      : string;
	ErtNumber : string;
	MusicId   : number;
	Title     : string;
	Style     : string;
	Orchestra : string;
	Singers   : string;
	Composer  : string;
	Author    : string;
	Label     : string;
    Soloist   : string;
	Director  : string;
}

interface AudioFile {
    Name : string;
	Path : string;
}

function App() {

    const classSelectedRow : string = "selected-row";

    const [relativePath, setRelativePath] = useState<string[]>(["C:\\Users\\ext.dozen\\Music\\TT-TTT"]);

    const [folderPath, setFolderPath] = useState<string>("C:\\Users\\ext.dozen\\Music\\TT-TTT\\");
    const [fileList, setFileList] = useState<AudioFile[]>([]);
    const [folderList, setFolderList] = useState<string[]>([]);    

    const [orchestra, setOrchestra] = useState<string>();
    const [singer, setSinger] = useState<string>();
    const [title, setTitle] = useState<string>();
    const [startDate, setStartDate] = useState<string>();
    const [endDate, setEndDate] = useState<string>();

    const [recordingList, setRecordingList] = useState<Recording[]>([]);

    const [selectedRecording, setSelectedRecording] = useState<number>(0);
    const [selectedFilePath, setSelectedFilePath] = useState<string>("");

    const [matchingRecords, setMatchingRecords] = useState<Mapping[]>([]);
    const [loading, setLoading] = useState<boolean>();

    useEffect(() => {
        getFilesInFolder();
    }, []);

    function importCsv(){
        ImportCsvFile();
    }

    function constructPath() : string {
        return relativePath.join('\\');
    }

    async function getFilesInFolder() {
        await getFoldersInFolder()
        setFileList(await GetAudioFilesInFolder(constructPath()).then(c => c))
    }

    async function getFoldersInFolder() {
        var folders = await GetFoldersInFolder(constructPath()).then(c => c)
        setFolderList(folders)
    }

    // const callRecordingsWithFilter = debounce(async () => {
    //     setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c))
    // }, 300);

    async function onOrchestraFilterChange(orchestra : string) {
        setOrchestra(orchestra);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c));      
    }

    async function onSingerFilterChange(singer : string) {
        setSinger(singer);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c));      
    }

    async function onTitleFilterChange(title : string) {
        setTitle(title);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c));     
    }

    async function onStartDateFilterChange(startDate : string) {
        setStartDate(startDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c));     
    }

    async function onEndDateFilterChange(endDate : string) {
        setEndDate(endDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate ?? '', endDate ?? '').then(c => c));      
    }

    async function getMatchingRecords() {

        if (fileList.length == 0) {
            return;
        }

        if (recordingList.length == 0) {
            return;
        }

        setMatchingRecords(removeDuplicates(await GetMatchingRecords(folderPath, orchestra ?? '', singer ?? '', title ?? '', "title", startDate ?? '', endDate ?? '')))
    }

    function removeDuplicates(mappings : Mapping[]) : Mapping[] {   
        return [...new Map(mappings.map(v => [v.RecordingTitle, v] || [v.FileName, v])).values()]
    }

    function findDuplicates(arr: Mapping[]): Mapping[] {
        return [];
        // return arr.filter((obj, index, array) => 
        //   array.slice(index + 1).some((otherObj) => obj.RecordingTitle == otherObj.RecordingTitle || obj.FileName == otherObj.FileName)
        // );
      }

    function onSelectRecordingRow(musicId : number) {
        setSelectedRecording(musicId);
    }

    function onSelectFileRow(path : string) {
        setSelectedFilePath(path);
    }
    
    async function addDirectory(newPath : string) {
        relativePath.push(newPath);
        setRelativePath(relativePath);
        await getFilesInFolder();
        setFolderPath(constructPath());
    }

    async function goBack() {
        relativePath.pop();
        setRelativePath(relativePath);
        await getFilesInFolder();
        setFolderPath(constructPath());
    }

    function addMappingToMatchingRecords() {
        setMatchingRecords([]);

        const mapping: Mapping = {
            MusicId  : selectedRecording,
            FilePath : selectedFilePath,
            FileName : selectedFilePath.substring(selectedFilePath.lastIndexOf("\\")+1),
            RecordingTitle : recordingList.filter(r=>r.MusicId == selectedRecording)[0].Title,
            MatchingWordOne : "",
            MatchingWordTwo : "",
            Finished : false
        }
        
        setMatchingRecords(removeDuplicates([...matchingRecords, mapping]));

        setSelectedFilePath("");
        setSelectedRecording(0);
    }

    async function isAllDoneEventCallback(isAllDone : boolean) {
        setFileList(await GetAudioFilesInFolder(constructPath()).then(c => c))
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title', startDate!, endDate!).then(c => c))
        
        setMatchingRecords([]);
        setLoading(false);
    }

    async function mappingEventCallback(musicId : number) {
        matchingRecords.filter(f => f.MusicId == musicId)[0].Finished = true;
        setMatchingRecords([...matchingRecords]);
    }

    async function mapAllMatchingRecordings() {
        EventsOn("mapping_done", async (musicId : number) => mappingEventCallback(musicId));
        EventsOn("mappings_all_done", async (isAllDone : boolean) => isAllDoneEventCallback(isAllDone));
        
        setLoading(true);
        await MapAllRecordings(matchingRecords)
    }

    function cleanMatchingRecordings() {
        setMatchingRecords([]);
    }

    function removeMatching(matching : Mapping) {
        setMatchingRecords(matchingRecords.filter(item => item !== matching));
    }

    function isFileSelectedAsAMatch(fileName : string) : boolean {
        var matched = matchingRecords.filter(m => m.FileName == fileName)[0]
        return matched != null;
    }

    function isRecordingSelectedAsAMatch(musicId : number) : boolean{
        var matched = matchingRecords.filter(m => m.MusicId == musicId)[0]
        return matched != null;
    }

    return (
        <div id="app">
            <div className='matches'>
                {matchingRecords.map((item, index) => (
                <div key={index}>
                    {item.Finished && <span className='green-background'>FINISHED</span>}
                    <span>({index}) {item.FileName} == {item.RecordingTitle} ({item.MusicId})</span>
                    {!item.Finished && <button onClick={() => removeMatching(item)} className='red-background'>Remove</button>}
                </div>
                ))}

                {loading && <span>Loading</span>}
                {matchingRecords.length == 0 ? <button onClick={getMatchingRecords}>Match Records</button> : ""}
                {matchingRecords.length != 0 ? <button onClick={mapAllMatchingRecordings} className='green-background'>Map All Now</button> : ""}
                {matchingRecords.length != 0 ? <button onClick={cleanMatchingRecordings} className='red-background'>Clear All</button> : ""}

                {/* <button onClick={importCsv}>Import CSV</button> */}
            </div>

            <div id="contents">
                <div id="left-panel" className="panel">
                    <div className='file-filters'>
                        <button onClick={goBack}>BACK</button>
                        <span>Folder Path</span>
                        <input type="text" id="folderPath" value={folderPath || ''} name="folderPath" onChange={(e) => setFolderPath(e.target.value)}/>
                    </div>
                    <div>
                        {folderList.map((item, index) => (
                            <button key={index} onClick={() => addDirectory(item)}>{item}</button>
                        ))}
                    </div>
                    <div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Filename</th>
                                </tr>
                            </thead>
                            <tbody>
                                {fileList.map((item, index) => (
                                <tr key={index} onClick={() => onSelectFileRow(item.Path)} 
                                    className={"recording-row " + 
                                    (selectedFilePath === item.Path ? "selected-row " : "") + 
                                    (isFileSelectedAsAMatch(item.Name) ? "to-be-matched-row " : "")
                                    }>
                                    {/* (findDuplicates(matchingRecords).filter(m => m.FileName == item.Name) ? "duplicate":"") */}
                                    <td>{index}: {item.Name}</td>
                                </tr>
                                ))}   
                            </tbody>
                        </table>
                    </div>
                </div>
                <div id="transfer-bar">
                <button onClick={addMappingToMatchingRecords}>Add Map</button>
                </div>
                <div id="right-panel" className="panel">

                    <div className='recording-filters'>
                        <div className='filters'>
                            <span>Orchestra</span>
                            <input type="text" id="orchestra" name="orchestra" value={orchestra || ''} onChange={(e) => onOrchestraFilterChange(e.target.value)}/>
                        </div>
                                        
                        <div className='filters'>
                            <span>Singer</span>
                            <input type="text" id="singer" name="singer" value={singer || ''} onChange={(e) => onSingerFilterChange(e.target.value)}/>
                        </div>

                        <div className='filters'>
                            <span>Title</span>
                            <input type="text" id="title" name="title" value={title || ''} onChange={(e) => onTitleFilterChange(e.target.value)}/>
                        </div>

                        <div className='filters'>
                            <span>Start</span>
                            <input type="text" maxLength={2} id="startDate" name="startDate" value={startDate || ''} onChange={(e) => onStartDateFilterChange(e.target.value)}/>
                        </div>

                        <div className='filters'>
                            <span>End</span>
                            <input type="text" maxLength={2} id="endDate" name="endDate" value={endDate || ''} onChange={(e) => onEndDateFilterChange(e.target.value)}/>
                        </div>
                    </div>
                    <div>
                        <table>
                            <thead>
                                <tr>
                                    <th>Index</th>
                                    <th>MusicId</th>
                                    <th>Title</th>
                                    <th>Orchestra</th>
                                    <th>Singer</th>
                                    <th>Style</th>
                                    <th>Date</th>
                                </tr>
                            </thead>
                            <tbody>
                                {recordingList.map((item, index) => (
                                <tr key={index} onClick={() => onSelectRecordingRow(item.MusicId)} 
                                className={"recording-row " + 
                                (selectedRecording === item.MusicId ? "selected-row " : "") + 
                                (isRecordingSelectedAsAMatch(item.MusicId) ? "to-be-matched-row " : "")}>
                                {/* (findDuplicates(matchingRecords).filter(m => m.MusicId == item.MusicId) ? "duplicate":"") */}
                                    <td>{index}</td>
                                    <td>{item.MusicId}</td>
                                    <td>{item.Title}</td>
                                    <td>{item.Orchestra}</td>
                                    <td>{item.Singers}</td>
                                    <td>{item.Style}</td>
                                    <td>{item.Date}</td>
                                </tr>
                                ))}   
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    )
}

export default App
