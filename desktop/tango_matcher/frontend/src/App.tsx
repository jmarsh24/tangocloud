import {useState} from 'react';
import './App.css';
import {ImportCsvFile, GetFoldersInFolder, GetAudioFilesInFolder, GetRecordingsWithFilter, PrintLog, GetSongTags, MapSong} from "../wailsjs/go/main/App";

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

    const [recordingList, setRecordingList] = useState<Recording[]>([]);

    const [selectedRecording, setSelectedRecording] = useState<number>(0);
    const [selectedFilePath, setSelectedFilePath] = useState<string>("");

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

    async function getRecordingsWithFilter() {
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title').then(c => c))
    }

    async function onSingerFilterChange(singer : string) {
        setSinger(singer);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title').then(c => c))
    }

    async function onTitleFilterChange(title : string) {
        setTitle(title);
        setRecordingList(await GetRecordingsWithFilter(orchestra ?? '', singer ?? '', title ?? '', 'title').then(c => c))
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

    function mapRecordingToFile() {
        MapSong(selectedRecording, selectedFilePath)
    }

    function printTags() {
        GetSongTags()
    }

    return (
        <div id="app">
            <div id="header" className="menu-bar">
                <button onClick={getFilesInFolder}>Get Songs in Directory</button>
            </div>
            <div id="contents">
                <div id="left-panel" className="panel">
                    <div className='file-filters'>
                        <button onClick={goBack}>BACK</button>
                        <span>Folder Path</span>
                        <input type="text" id="folderPath" value={folderPath} name="folderPath" onChange={(e) => setFolderPath(e.target.value)}/>
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
                                <tr key={index} onClick={() => onSelectFileRow(item.Path)} className={"recording-row " + (selectedFilePath === item.Path ? "selected-row" : "")}>
                                    <td>{item.Name}</td>
                                </tr>
                                ))}   
                            </tbody>
                        </table>


                    </div>
                </div>
                <div id="transfer-bar">
                <button onClick={mapRecordingToFile}>Map</button>
                </div>
                <div id="right-panel" className="panel">

                    <div className='recording-filters'>
                        <div className='filters'>
                            <span>Orchestra</span>
                            <input type="text" id="orchestra" name="orchestra" value={orchestra} onChange={(e) => setOrchestra(e.target.value)}/>
                        </div>
                                        
                        <div className='filters'>
                            <span>Singer</span>
                            <input type="text" id="singer" name="singer" value={singer} onChange={(e) => onSingerFilterChange(e.target.value)}/>
                        </div>

                        <div className='filters'>
                            <span>Title</span>
                            <input type="text" id="title" name="title" value={title} onChange={(e) => onTitleFilterChange(e.target.value)}/>
                        </div>
                    </div>
                    
                    <div>
                        <table>
                            <thead>
                                <tr>
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
                                <tr key={index} onClick={() => onSelectRecordingRow(item.MusicId)} className={"recording-row " + (selectedRecording === item.MusicId ? "selected-row" : "")}>
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
            <div id="footer" className="menu-bar"></div>
        </div>
    )
}

export default App
