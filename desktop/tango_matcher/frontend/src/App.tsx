import {useEffect, useCallback} from 'react';
import './App.css';
import {EventsOn, LogPrint} from "../wailsjs/runtime/runtime"
import {CheckById, ImportCsvFile, GetFoldersInFolder, GetAudioFilesInFolder, GetRecordingsWithFilter, GetMatchingRecords, MapAllRecordings, CreateDirectoryTree} from "../wailsjs/go/main/App";
import useState from 'react-usestateref';

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

    const [folderText, setFolderText] = useState<string>('');
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


    const [keyboardSelectMode, setKeyboardSelectMode] = useState<number>(0);
    const [commandMode, setCommandMode] = useState<boolean>(false);
    const [selectedNumber, setSelectedNumber] = useState<string>('');

    useEffect(() => {
        //getFilesInFolder();
    }, []);

    const handleUserKeyPress = useCallback((event:any) => {
        const { key, keyCode } = event;

        if(keyCode === 27) {
            setCommandMode(true);
        }

        if(commandMode && (keyCode >= 96 && keyCode <= 105)) {
            LogPrint("New Selected Number: " + selectedNumber + key);
            setSelectedNumber(selectedNumber + key);

            switch(keyboardSelectMode) {
                case 0:
                    selectFileByKeyboard(selectedNumber + key); break;
                case 1:
                    selectRecordingByKeyboard(selectedNumber + key);break;
            }
        }

        if(commandMode && (keyCode == 70 || keyCode == 77 || keyCode == 82)) {
            switch(key) {
                case 'm':
                    addMappingToMatchingRecords(); break;
                case 'f':
                    setKeyboardSelectMode(0); break;
                case 'r':
                    setKeyboardSelectMode(1); break;
            }
            setSelectedNumber('');
        }
    }, [commandMode, keyboardSelectMode, selectedNumber, selectedFilePath, selectedRecording]);

    useEffect(() => {
        window.addEventListener("keydown", handleUserKeyPress);
        return () => {
            window.removeEventListener("keydown", handleUserKeyPress);
        };
    }, [handleUserKeyPress]);

    function selectFileByKeyboard(key: string) {
        setSelectedFilePath(fileList[Number(key)].Path);
    }

    function selectRecordingByKeyboard(key: string) {
        setSelectedRecording(recordingList[Number(key)].MusicId);
    }

    function importCsv(){
        //ImportCsvFile();
        CheckById();
    }

    async function getFilesInFolder(fp : string) {
        await getFoldersInFolder(fp)
        setFileList(await GetAudioFilesInFolder(fp).then(c => c))
    }

    async function getFoldersInFolder(fp : string) {
        var folders = await GetFoldersInFolder(fp).then(c => c)
        setFolderList(folders)
    }

    async function onOrchestraFilterChange(orchestra : string) {
        setCommandMode(false);
        setOrchestra(orchestra);
        setStartDate('');
        setEndDate('');
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onSingerFilterChange(singer : string) {
        setCommandMode(false);
        setSinger(singer);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onTitleFilterChange(title : string) {
        setCommandMode(false);
        setTitle(title);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onStartDateFilterChange(startDate : string) {
        setCommandMode(false);
        setStartDate(startDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function onEndDateFilterChange(endDate : string) {
        setCommandMode(false);
        setEndDate(endDate);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '').then(c => c));
    }

    async function getMatchingRecords() {
        setCommandMode(true);

        if (fileList.length == 0) return;
        if (recordingList.length == 0) return;

        setMatchingRecords(removeDuplicates(await GetMatchingRecords(folderText, orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate ?? '', endDate ?? '')))
    }

    function removeDuplicates(mappings : Mapping[]) : Mapping[] {
        return [...new Map(mappings.map(v => [v.RecordingTitle, v] || [v.FileName, v])).values()]
    }

    function onSelectRecordingRow(musicId : number) {
        setSelectedRecording(musicId);
    }

    function onSelectFileRow(path : string) {
        setSelectedFilePath(path);
    }

    async function goToFolder(){
        await getFilesInFolder(folderText)
    }

    async function addDirectory(newPath : string) {
        setFolderText(folderText+'\\'+newPath);
        await getFilesInFolder(folderText+'\\'+newPath);
    }

    async function goBack() {
        const parts: string[] = folderText.split('\\');
        parts.pop();
        const result: string = parts.join('\\');

        setFolderText(result);
        await getFilesInFolder(result);
    }

    function addMappingToMatchingRecords() {
        const mapping: Mapping = {
            MusicId  : selectedRecording,
            FilePath : selectedFilePath,
            FileName : selectedFilePath.substring(selectedFilePath.lastIndexOf("\\")+1),
            RecordingTitle : recordingList.filter(r=>r.MusicId == selectedRecording)[0].Title,
            MatchingWordOne : "",
            MatchingWordTwo : "",
            Finished : false
        }

        setMatchingRecords([]);
        setMatchingRecords(removeDuplicates([...matchingRecords, mapping]));
        setSelectedFilePath("");
        setSelectedRecording(0);
    }

    async function isAllDoneEventCallback(isAllDone : boolean) {
        setFileList(await GetAudioFilesInFolder(folderText).then(c => c))
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', orderBy, startDate!, endDate!).then(c => c))

        setMatchingRecords([]);
        setLoading(false);
    }

    async function mappingEventCallback(musicId : number) {
        matchingRecords.filter(f => f.MusicId == musicId)[0].Finished = true;
        setMatchingRecords([...matchingRecords]);

        if(!matchingRecords.filter(f=>!f.Finished)[0]) {
            setFileList(await GetAudioFilesInFolder(folderText).then(c => c))
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

    function createDirectoryTree() {
        CreateDirectoryTree(folderText)
    }

    return (
        <div id="app">

                <div id="left" className='panel'>
                    <div className='commands'>
                        <button onClick={goBack}>BACK</button>
                        <div className='folder-filter'>
                            <span className='folder-label'>Folder Path</span>
                            <input className='folder-value' type="text" id="folderText" value={folderText} name="folderText"
                                   onChange={(e) => setFolderText(e.target.value)}/>
                        </div>
                        <button onClick={goToFolder}>GO</button>
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
                            <button onClick={cleanMatchingRecordings} className='red-background'>Clear
                                All</button> : ""}
                        <button onClick={addMappingToMatchingRecords}>Add Map</button>
                    </div>

                    {matchingRecords.map((item, index) => (
                        <div key={index} className='matching-data'>
                            <div>{index}</div>
                            <div className='mapping'>
                                <p className='p-slim'>{item.FileName.length > 45 ? item.FileName.substring(0, 50) + '...' : item.FileName}</p>
                                <p className='p-slim'>{item.RecordingTitle.length > 45 ? item.RecordingTitle.substring(0, 45) + '...' : item.RecordingTitle} [{item.MusicId}]</p>
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
                            <input type="text" maxLength={2} id="startDate" name="startDate" value={startDate || ''} className='date-input'
                                   onChange={(e) => onStartDateFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter'>
                            <span className='label'>End</span>
                            <input type="text" maxLength={2} id="endDate" name="endDate" value={endDate || ''} className='date-input'
                                   onChange={(e) => onEndDateFilterChange(e.target.value)}/>
                        </div>

                        <div className='filter dates' onChange={onOrderByChange}>
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
                                <th>Ert</th>
                                <th>Title</th>
                                <th>Orchestra</th>
                                <th>Singer</th>
                                <th></th>
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
                                    <td>{item.Style.substring(0,1)}</td>
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
