import {useEffect, useState} from 'react';
import './App.css';
import {EventsOn} from "../wailsjs/runtime/runtime"
import {ImportCsvFile, GetFoldersInFolder, GetAudioFilesInFolder, GetRecordingsWithFilter, PrintLog, MapSong, GetMatchingRecords, MapAllRecordings} from "../wailsjs/go/main/App";

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
    const [orderBy, setOrderBy] = useState<string>('title');

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
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onSingerFilterChange(singer : string) {
        setSinger(singer);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onTitleFilterChange(title : string) {
        setTitle(title);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onStartDateFilterChange(startDate : string) {
        setStartDate(startDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onEndDateFilterChange(endDate : string) {
        setEndDate(endDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function getMatchingRecords() {

        if (fileList.length == 0) {
            return;
        }

        if (recordingList.length == 0) {
            return;
        }

        setMatchingRecords(removeDuplicates(await GetMatchingRecords(folderPath, orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '')))
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
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate!, endDate!).then(c => c))

        setMatchingRecords([]);
        setLoading(false);
    }

    async function mappingEventCallback(musicId : number) {
        matchingRecords.filter(f => f.MusicId == musicId)[0].Finished = true;
        setMatchingRecords([...matchingRecords]);

        if(!matchingRecords.filter(f=>!f.Finished)[0]) {
            PrintLog("ALL FINISHED")
            setFileList(await GetAudioFilesInFolder(constructPath()).then(c => c))

            setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c))

            setMatchingRecords([]);
            setLoading(false);
        }
    }

    async function mapAllMatchingRecordings() {
        EventsOn("mapping_done", async (musicId : number) => mappingEventCallback(musicId));
        //EventsOn("mappings_all_done", async (isAllDone : boolean) => isAllDoneEventCallback(isAllDone));

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

    const onOrderByChange = async (e : React.ChangeEvent<HTMLInputElement>) => {
        setOrderBy(e.target.value);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', e.target.value, startDate ?? '', endDate ?? '').then(c => c));
    }

    return (
        <div id="app">

                <div id="left" className='panel'>
                    <div className='commands'>
                        <button onClick={goBack}>BACK</button>
                        <div className='filter'>
                            <span className='label'>Folder Path</span>
                            <input type="text" id="folderPath" value={folderPath || ''} name="folderPath"
                                   onChange={(e) => setFolderPath(e.target.value)}/>
                        </div>
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
                                <th></th>
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
                                    <td>{index}</td>
                                    <td>{item.Name}</td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                    </div>
                </div>

                <div id='matches' className='panel'>
                    <div className='commands'>
                        {loading && <span className='red-background'>LOADING</span>}
                        {matchingRecords.length == 0 ? <button onClick={getMatchingRecords}>Match Records</button> : ""}
                        {matchingRecords.length != 0 ?
                            <button onClick={mapAllMatchingRecordings} className='green-background'>Map All
                                Now</button> : ""}
                        {matchingRecords.length != 0 ?
                            <button onClick={cleanMatchingRecordings} className='red-background'>Clear All</button> : ""}
                        <button onClick={addMappingToMatchingRecords}>Add Map</button>
                    </div>

                    {matchingRecords.map((item, index) => (
                        <div key={index} className='matching-data'>
                            <div>{index}</div>
                            <div className='mapping'>
                                <p className='p-slim'>{item.FileName.substring(0, 45) + '...'}</p>
                                <p className='p-slim'>{item.RecordingTitle.substring(0, 40) + '...'} [{item.MusicId}]</p>
                            </div>
                            {item.Finished && <span className='green-background'>FINISHED</span>}
                            {!item.Finished &&
                                <button onClick={() => removeMatching(item)} className='red-background'>Remove</button>}
                        </div>
                    ))}
                </div>

                <div id="right" className='panel'>
                    <div className='commands'>
                        <div className='filter'>
                            <span className='label'>Orchestra</span>
                            <input type="text" id="orchestra" name="orchestra" value={orchestra || ''}
                                   onChange={(e) => onOrchestraFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter'>
                            <span className='label'>Singer</span>
                            <input type="text" id="singer" name="singer" value={singer || ''}
                                   onChange={(e) => onSingerFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter'>
                            <span className='label'>Title</span>
                            <input type="text" id="title" name="title" value={title || ''}
                                   onChange={(e) => onTitleFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter'>
                            <span className='label'>Start</span>
                            <input type="text" maxLength={2} id="startDate" name="startDate" value={startDate || ''}
                                   onChange={(e) => onStartDateFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter'>
                            <span className='label'>End</span>
                            <input type="text" maxLength={2} id="endDate" name="endDate" value={endDate || ''}
                                   onChange={(e) => onEndDateFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter' onChange={onOrderByChange}>
                            <input type="radio" id="title" name="orderby" value="title" checked={orderBy === "title"}/>
                            <label htmlFor="title">Title</label><br/>
                            <input type="radio" id="date" name="orderby" value="date" checked={orderBy === "date"}/>
                            <label htmlFor="date">Date</label><br/>
                        </div>
                    </div>
                        <table className='recording-table'>
                            <thead>
                            <tr>
                                <th></th>
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
                                    <td>{item.Date.substring(0, 10)}</td>
                                </tr>
                            ))}
                            </tbody>
                        </table>
                </div>

        </div>
    )
}

export default App
